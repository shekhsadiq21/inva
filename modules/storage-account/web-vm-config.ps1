param (
  $MQ_IP,
  $storageaccount,
  $containername,
  $ad_pass,
  $redis_name,
  $redis_ssl_port,
  $redis_pass,
  $jwt_secret,
  $ld_sdk_id,
  $has_sso_ssl_certificate,
  $env
)

Start-Transcript c:\web-vm-config.ps1.log

Add-MpPreference -ExclusionPath "C:\Periscope\log" -Force -ErrorAction Stop
Add-MpPreference -ExclusionPath "C:\Periscope\bin\RRA\Data\Log" -Force -ErrorAction Stop

$redis_pass = $redis_pass.Replace("+", "%2B")
az login --identity
az storage blob download `
  --account-name ${artifact_storage_account_name} `
  --container-name ${artifact_storage_container_name} `
  --auth-mode login `
  --file C:\temp\stunnel.exe `
  --name installer/stunnel-5.60-win64-installer.exe
az storage blob download `
  --account-name ${artifact_storage_account_name} `
  --container-name ${artifact_storage_container_name} `
  --auth-mode login `
  --file C:\Temp\redis_php_ext.zip `
  --name library/php_redis-4.3.0-7.2-nts-vc15-x64.zip

[System.Environment]::SetEnvironmentVariable('LD_CLIENT_SDK_ID', $ld_sdk_id, [System.EnvironmentVariableTarget]::Machine)

cd C:\temp
.\stunnel.exe /AllUsers /S | Out-Null
Set-Content -Path "C:\Program Files (x86)\stunnel\config\stunnel.conf" "[redis-cli]`nCAfile=ca-certs.pem`ncert=stunnel.pem`nclient=yes`naccept=127.0.0.1:6380`nconnect=$($redis_name).privatelink.database.windows.net:$($redis_ssl_port)"
cd C:\"Program Files (x86)"\stunnel\bin
.\openssl.exe req -new -newkey rsa:2048 -nodes -x509 -subj "/C=CA/ST=Ontario/L=Toronto/O=InvaFresh/CN=${customer_url_prefix}.invafresh.com" -keyout C:\"Program Files (x86)"\stunnel\config\stunnel.pem  -out C:\"Program Files (x86)"\stunnel\config\stunnel.pem | Out-Null
.\stunnel.exe -install -quiet -start | Out-Null
Start-Service -Name stunnel

Write-Host "Download Redis extension for PHP, move it to ext folder, and update php.ini"
cd C:\Temp
Expand-Archive -LiteralPath 'C:\Temp\redis_php_ext.zip' -DestinationPath C:\Temp\redis_php_ext\
Move-Item -Path C:\Temp\redis_php_ext\php_redis.dll -Destination C:\Periscope\PHP7\ext\php_redis.dll
cd C:\Periscope\bin
.\Proxy.exe -c "C:\Periscope\PHP7\php.ini" -C "SET PHP\extension=ICAPLib4PHP7.dll"
.\Proxy.exe -c "C:\Periscope\PHP7\php.ini" -C "SET Session\session.save_handler=redis"
Remove-Item -Force -Recurse C:\Temp\redis_php_ext\
Remove-Item -Force C:\Temp\redis_php_ext.zip

$tcpString = "tcp://127.0.0.1:6380?auth=$($redis_pass)"

.\Proxy.exe -c "c:\periscope\php7\php.ini" -C "SET Session\session.save_path=$($tcpString)"
$quotedString = $tcpString.Insert(0, '"')
$quotedString = $quotedString.Insert($quotedString.Length, '"')
$phpConfig = Get-Content -Path C:\Periscope\PHP7\php.ini
$phpConfig = $phpConfig.Replace($tcpString, $quotedString)
$phpConfig = $phpConfig.Replace(";extension=sqlite3", "extension=php_redis.dll")
$phpConfig = $phpConfig.Replace(";extension=curl", "extension=curl")
Set-Content -Path C:\Periscope\PHP7\php.ini -Value $phpConfig

mkdir "C:\Periscope\PHP7\tmp" -force
cd C:\Periscope\bin
.\Proxy.exe -c "C:\Periscope\PHP7\php.ini" -C "SET PHP\extension=ICAPLib4PHP7.dll"
.\Proxy.exe -C "SET Common\MQ_IP=$($MQ_IP)"
.\Proxy.exe -C "SET CLIENT::PROXY\TCPIP_Port=5803"

az login --identity

if ($has_sso_ssl_certificate -eq "true") {
  az storage blob download-batch --account-name $storageaccount -s $containername -d "C:\Periscope" --auth-mode login --pattern "Web-$env/*"
  $sourcePath = "C:\Periscope\Web-$env" # Path to the source directory
  $destinationPath = "C:\Periscope\Web" # Path to the destination directory
  $certPath = "C:\Periscope\Web-$env\sso.cer" # Path to the certificate file
  $ConfigLarry = "C:\Periscope\Web\ConfigLarry.txt" # Larry config file for sso

  if (Test-Path $destinationPath) {
    # Check if the destination directory already exists
    Write-Host "Destination directory already exists."
  }
  else {
    New-Item -ItemType Directory -Path $destinationPath # Create the destination directory if it doesn't exist
    Write-Host "Destination directory created."
  }

  if (Test-Path $certPath) {
    # Check if the certificate file exists
    Move-Item $certPath -Destination "C:\Periscope\" # Move the certificate file to the destination directory
    Write-Host "Certificate file moved to destination."
  }
  else {
    Write-Host "Certificate file not found"
  }

  
  if (Test-Path $sourcePath) {
    # Check if the source directory exists
    Get-ChildItem $sourcePath -Recurse -Include *| Move-Item -Destination $destinationPath # Move the contents of the source directory to the destination directory
    Write-Host "Contents of Web-dev moved to Web."
  }
  else {
    Write-Host "Source directory does not exist."
  }




}
else {
  az storage blob download-batch --account-name $storageaccount -s $containername -d "C:\Periscope" --auth-mode login --pattern "Web/*"

}

$phpconfigfile = get-content C:\Periscope\Web\ConfigUI.php
$phpconfigfile = $phpconfigfile.Replace("'MQ_IP', 'localhost'", "'MQ_IP', '$($MQ_IP)'")
set-content -path C:\Periscope\UserInterface\PERISCOPE\Config.php -Value $phpconfigfile

$phpmoconfigfile = get-content C:\Periscope\Web\ConfigMo.php
$phpmoconfigfile = $phpmoconfigfile.Replace("'MQ_IP', 'localhost'", "'MQ_IP', '$($MQ_IP)'")
set-content -path C:\Periscope\UserHandheld\POCKETPERISCOPE\Config.php -Value $phpmoconfigfile

$phptsconfigfile = get-content C:\Periscope\Web\ConfigTS.php
$phptsconfigfile = $phptsconfigfile.Replace("'MQ_IP', 'localhost'", "'MQ_IP', '$($MQ_IP)'")
set-content -path C:\Periscope\UserInterface\TOUCHSCREEN\Config.php -Value $phptsconfigfile

$phpjwtconfigfile = get-content C:\Periscope\UserInterface\JwtWebService\Config.php
$phpjwtconfigfile = $phpjwtconfigfile.Replace("'MQ_IP', 'localhost'", "'MQ_IP', '$($MQ_IP)'")
$phpjwtconfigfile = $phpjwtconfigfile.Replace("'JWT_SECRET', 'icap JWT_SECRET'", "'JWT_SECRET', '$($jwt_secret)'")
set-content -path C:\Periscope\UserInterface\JwtWebService\Config.php -Value $phpjwtconfigfile
$larryPath = "C:\Larry\Server"
if (Test-Path $larryPath) {
  write-output "Larry is present on this server, configuring it as well."
  choco install urlrewrite -y
  Add-WebConfiguration //defaultDocument/files "IIS:\sites\Larry" -atIndex 0 -Value @{value = "index.php" }
  New-WebHandler -Name "FastCGI" -Path "*.php" -Verb "*" -Modules FastCgiModule -PSPath "IIS:\sites\Larry" -ScriptProcessor "C:\Larry\chad_php\php-cgi.exe" -ResourceType "File"  
  $larryconfigfile = get-content "$($larryPath)\.env.example"
  $larryconfigfile = $larryconfigfile -replace "MQ_IP=localhost", "MQ_IP=$($MQ_IP)"
  $larryconfigfile = $larryconfigfile -replace "JWT_SECRET=", "JWT_SECRET=$($jwt_secret)"
  Set-Content -Path "$($larryPath)\.env" -Value $larryconfigfile

  if ($env -eq "dev"){
  $larryconfigfile = get-content "$($larryPath)\.env"
  $larryconfigfile = $larryconfigfile -replace "APP_ENV=.*", "APP_ENV=develop"
  $larryconfigfile = $larryconfigfile -replace "APP_DEBUG=.*", "APP_DEBUG=def"
  Set-Content -Path "$($larryPath)\.env" -Value $larryconfigfile
  }
  elseif ($env -eq "qa") {
  $larryconfigfile = get-content "$($larryPath)\.env"
  $larryconfigfile = $larryconfigfile -replace "APP_ENV=.*", "APP_ENV=staging"
  $larryconfigfile = $larryconfigfile -replace "APP_DEBUG=.*", "APP_DEBUG=false"
  Set-Content -Path "$($larryPath)\.env" -Value $larryconfigfile
  }

  else {
  $larryconfigfile = get-content "$($larryPath)\.env"
  $larryconfigfile = $larryconfigfile -replace "APP_ENV=.*", "APP_ENV=production"
  $larryconfigfile = $larryconfigfile -replace "APP_DEBUG=.*", "APP_DEBUG=false"
  Set-Content -Path "$($larryPath)\.env" -Value $larryconfigfile
  }

  $larryConfigPhp = get-content "$($larryPath)\app\Http\ICAP\lib\Config_Example.php"
  $larryConfigPhp = $larryConfigPhp -replace "define('MQ_IP', env('MQ_IP', 'localhost'));", "define('MQ_IP', env('MQ_IP', '$($MQ_IP)'));"
  Set-Content -Path "$($larryPath)\app\Http\ICAP\lib\Config.php" -Value $larryConfigPhp
  if ($has_sso_ssl_certificate -eq "true"){
    if (Test-Path $ConfigLarry) {
    # Check if the Sso configlarry file exists
    $larryfile = Get-Content -Path $ConfigLarry 
    Add-Content -Path "C:\Larry\Server\.env" -Value $larryfile -Force # Append sso values to env file
    Write-Host "Larryfile file Content added to env file "
    }
    else {
    Write-Host "Larry file not found"
   }
  }
}
else {
  write-output "No Larry present on this server"
}

try {
  Write-Host "Binding IIS port 443 with SSL cert."
  Import-Module WebAdministration
  Get-ChildItem cert:\localmachine\MY -Recurse | Where-Object { $_.Subject -like '*invafresh.com*' } | New-Item -Path IIS:\SslBindings\!443
  Get-ChildItem cert:\localmachine\MY -Recurse | Where-Object { $_.Subject -like '*invafresh.com*' } | New-Item -Path IIS:\SslBindings\!6443
  if (Test-Path $larryPath) {
    Get-ChildItem cert:\localmachine\MY -Recurse | Where-Object { $_.Subject -like '*invafresh.com*' } | New-Item -Path IIS:\SslBindings\!8000
  }

}
catch {
  write-host "Failed IIS binding. Bindings already exist."
}

$ACL = Get-Acl -Path "C:\inetpub\logs\LogFiles\W3SVC1";
$AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("ddagentuser", "FullControl", "Allow");
$ACL.SetAccessRule($AccessRule);
$ACL | Set-Acl -Path "C:\inetpub\logs\LogFiles\W3SVC1";
$StarACL = Get-Acl -Path "C:\inetpub\logs\LogFiles\W3SVC1\*";
$StarAccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("ddagentuser", "FullControl", "Allow");
$StarACL.SetAccessRule($StarAccessRule);
$StarACL | Set-Acl -Path "C:\inetpub\logs\LogFiles\W3SVC1\*";
& "$env:ProgramFiles\Datadog\Datadog Agent\bin\agent.exe" restart-service;


az storage blob download --account-name $storageaccount  --container-name $containername  --file ${pocket_menu_option_file} --name ${pocket_menu_option_file} --auth-mode login
copy-item -path ${pocket_menu_option_file} -Destination "C:\Periscope\UserHandheld\POCKETPERISCOPE\${pocket_menu_option_file}"

cd C:\Periscope
rm *pfx, *pem
az keyvault secret download --vault-name sllcertvault -n GSinvafreshSSL --file cert.pfx -e base64
cd "C:\Program Files\OpenSSL-Win64\bin"
.\openssl.exe pkcs12 -in C:\Periscope\cert.pfx -nocerts -out C:\Periscope\key.pem -nodes -passin "pass:"
.\openssl.exe pkcs12 -in C:\Periscope\cert.pfx -clcerts -nokeys -out C:\Periscope\clcerts.pem -passin "pass:"
.\openssl.exe pkcs12 -in C:\Periscope\cert.pfx -cacerts -nokeys -chain -out C:\Periscope\cacerts.pem -passin "pass:"
cd C:\Periscope
get-content clcerts.pem, cacerts.pem | set-content WScert.pem
rm C:\Periscope\cert.pfx

C:\Periscope\bin\proxy.exe -s Restart
# proxy/rra does not stop correctly at first startup when app gateway targets TCP port 5803
# we need to track the Proxy.exe process id to force stop it
$Services = Get-WmiObject -Class win32_service -Filter "state = 'stop pending'"
if ($Services) {
  foreach ($service in $Services) {
    try {
      Stop-Process -Id $service.processid -Force -PassThru -ErrorAction Stop
    }
    catch {
      Write-Warning -Message "Error. Error details: $_.Exception.Message"
    }
  }
}
else {
  Write-Output "No services with 'Stopping'.status"
}

try {
  $Name = "invafreshds.com"
  $User = "aaddcdevops@invafreshds.com"
  $Restart = "true"
  $options = 3
  $OUPath = "OU=Periscope_TF_AZVMs,DC=invafreshds,DC=com"
  $password = $ad_pass
  [securestring]$secStringPassword = ConvertTo-SecureString $password -AsPlainText -Force
  [pscredential]$credObject = New-Object System.Management.Automation.PSCredential ($User, $secStringPassword)

  try {
    Add-Computer -DomainName "invafreshds.com" -OUPath $OUPath -Credential $credObject -Force -ErrorAction stop
    write-host "Success OU Join"
  }
  catch {
    write-host "Failed OU Join: $_"
    Add-Computer -DomainName "invafreshds.com" -Credential $credObject -Force
    Write-Host "Success without OU Join"
  }

  net localgroup "Remote Desktop Users" "invafreshds\RDP_users" /add
}
catch {
  Write-Host "Error joining domain. This is expected if the VM has already been joined."
  Write-Host "Error: $_"
}

$acl = Get-Acl -Path "C:\Periscope"
$acl.SetAccessRuleProtection($true, $true)
$acl | Set-Acl -Path "C:\Periscope"

#Remove modify rights from Authenticated Users
$acl = Get-Acl -Path "C:\Periscope"
$identity = "NT AUTHORITY\Authenticated Users"
$rule = $acl.Access | Where { $_.IdentityReference -eq $identity -and $_.FileSystemRights -like '*Modify*' }
$acl.RemoveAccessRule($rule)
$acl | Set-Acl -Path "C:\Periscope"

#Remove special permissions from Authenticated Users, must be in separate step to work
$acl = Get-Acl -Path "C:\Periscope"
$rule = $acl.Access | Where { $_.IdentityReference -eq $identity }
$acl.RemoveAccessRule($rule)
$acl | Set-Acl -Path "C:\Periscope"

#Set IIS Svc account permissions on PHP7 directory
$acl = get-acl -path "C:\Periscope"
$permission = "IIS_IUSRS", 
"FullControl",  
[System.Security.AccessControl.InheritanceFlags]"ContainerInherit, ObjectInherit", 
[system.security.accesscontrol.PropagationFlags]"None",
"Allow"
$AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($permission)
$acl.SetAccessRule($AccessRule)
$acl | set-acl -path "C:\Periscope"

if (Test-Path $larryPath) {
  $acl | set-acl -path "C:\Larry"
}


#Remove permission inheritance on key.pem
$acl = Get-Acl -Path "C:\Periscope\key.pem"
$acl.SetAccessRuleProtection($True, $True)
$acl | Set-Acl -Path "C:\Periscope\key.pem"

#Remove ACLs for Users and IIS_IUSRS for key.pem
$acl = Get-Acl -Path "C:\Periscope\key.pem"
$userAccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("Users", "ReadandExecute", "Allow");
$IISAccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("IIS_IUSRS", "FullControl", "Allow");
$acl.RemoveAccessRule($useraccessrule)
$acl.RemoveAccessRule($IISaccessrule)
$acl | Set-Acl -Path "C:\Periscope\key.pem"

Stop-Transcript

# Apply Domain join by rebooting the VM
Restart-Computer
