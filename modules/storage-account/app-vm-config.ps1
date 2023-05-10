param (
    $sql_server_fqdn,
    $mq_ip,
    $db_name,
    $sql_server_pass,
    $subject_list,
    [int]$DSS2_count,
    [int]$TRAX_count,
    $ad_pass,
    $recipemngrstorageaccount,
    $recipemngrcontainername,
    $esha_ip,
    $storageaccount,
    $containername
)

Start-Transcript c:\app-vm-config.ps1.log

Add-MpPreference -ExclusionPath "C:\Periscope\log" -Force -ErrorAction Stop
Add-MpPreference -ExclusionPath "C:\Periscope\bin\RRA\Data\Log" -Force -ErrorAction Stop

C:\Windows\System32\odbcconf.exe CONFIGSYSDSN "ODBC Driver 17 for SQL Server" "DSN=Periscope|Trusted_Connection=No|SERVER=$sql_server_fqdn|Database=$db_name"
cd C:\Periscope\bin
.\Proxy.exe -C "SET Common\MQ_IP=$($mq_ip)"
.\Proxy.exe -C "SET DataBase\DSN=Periscope"
.\Proxy.exe -C "SET DataBase\UserID=PeriScope"

$iniConfig=$(Get-Content -Path C:\Periscope\dat\invatron.ini)
$iniConfig = $iniConfig.Replace("Password=...","Password='$sql_server_pass'")
if ( "DISABLED" -notlike $esha_ip )
{
  $iniConfig = $iniConfig.Replace(";UpdateServerHost=","UpdateServerHost=$esha_ip")
  $iniConfig = $iniConfig.Replace(";UpdateServerPort=5803","UpdateServerPort=5803")
}
Set-Content -Path C:\Periscope\dat\iNVATRON.ini -Value $iniConfig
# .\Proxy.exe -C "SET DataBase\Password=$($sql_server_pass)"

do {
  Write-Host "waiting for SQL server to be available..."
  Start-Sleep 3      
} until(Test-NetConnection $sql_server_fqdn -Port 1433 | Where-Object { $_.TcpTestSucceeded } )
Write-Host "TCP connection success with SQL server!"

Write-Host "Run Periscope.SysTable Storage account specific SQL queries..."
$systable_upsert = @'
UPDATE Periscope.SysTable SET Value='1' WHERE SysKey='PeriScope\StorageLocation'
IF @@ROWCOUNT = 0
  INSERT INTO Periscope.SysTable (SysKey,Value) VALUES ('PeriScope\StorageLocation','1')

UPDATE Periscope.SysTable SET Value='_STORAGEACCOUNT_' WHERE SysKey='PeriScope\CloudStorageAcccount'
IF @@ROWCOUNT = 0
  INSERT INTO Periscope.SysTable (SysKey,Value) VALUES ('PeriScope\CloudStorageAcccount','_STORAGEACCOUNT_')

UPDATE Periscope.SysTable SET Value='_STORAGECONTAINER_' WHERE SysKey='PeriScope\CloudStorageContainer'
IF @@ROWCOUNT = 0
  INSERT INTO Periscope.SysTable (SysKey,Value) VALUES ('PeriScope\CloudStorageContainer','_STORAGECONTAINER_')
'@

$systable_upsert = $systable_upsert.Replace('_STORAGEACCOUNT_', $recipemngrstorageaccount).Replace('_STORAGECONTAINER_', $recipemngrcontainername)

$systable_upsert_params = @{
	'Database' = $db_name
	'ServerInstance' = $sql_server_fqdn
	'Username' = $sql_server_user
	'Password' = $sql_server_pass
	'Query' = $systable_upsert
  'OutputSqlErrors' = $true
}

Invoke-Sqlcmd @systable_upsert_params

Write-Host "Run Periscope.SysTable ESHA specific SQL queries..."
if ( "DISABLED" -notlike $esha_ip )
{
    $esha_systable_upsert = @'
UPDATE Periscope.SysTable SET Value='ESHAIP' WHERE SysKey='PeriScope\EshaHost'
IF @@ROWCOUNT = 0
  INSERT INTO Periscope.SysTable (SysKey,Value) VALUES ('PeriScope\EshaHost','ESHAIP')

UPDATE Periscope.SysTable SET Value='5803' WHERE SysKey='PeriScope\EshaPort'
IF @@ROWCOUNT = 0
  INSERT INTO Periscope.SysTable (SysKey,Value) VALUES ('PeriScope\EshaPort','5803')

UPDATE Periscope.SysTable SET Value='C:\Program Files (x86)\ESHA Research\ESHAPortSQL\ESHAPortSQL.exe' WHERE SysKey='PeriScope\ESHAPortSQLApp'
IF @@ROWCOUNT = 0
  INSERT INTO Periscope.SysTable (SysKey,Value) VALUES ('PeriScope\ESHAPortSQLApp','C:\Program Files (x86)\ESHA Research\ESHAPortSQL\ESHAPortSQL.exe')

UPDATE Periscope.SysTable SET Value='100' WHERE SysKey='PeriScope\EshaWaitTimeout'
IF @@ROWCOUNT = 0
  INSERT INTO Periscope.SysTable (SysKey,Value) VALUES ('PeriScope\EshaWaitTimeout','100')
'@

    $esha_systable_upsert = $esha_systable_upsert.Replace('ESHAIP', $esha_ip)
    $esha_systable_upsert_params = @{
        'Database' = $db_name
        'ServerInstance' = $sql_server_fqdn
        'Username' = $sql_server_user
        'Password' = $sql_server_pass
        'Query' = $esha_systable_upsert
        'OutputSqlErrors' = $true
    }
    Invoke-Sqlcmd @esha_systable_upsert_params
}

Write-Host "Installing Periscope..."
$svclist = (Get-Service | ?{$_.Name -like '*Periscope*'} | select Name).name
$subs = $subject_list.split(" ")
function Install-PeriApp {
    param (
        $Subj = "USRI:25",
        $cnt,
        $app
    )
    $len = $subj.length
    $sbj = $subj.substring(0,4)
    $sbjcount = $subj.substring(5,$len-5)

    for ($num = 1; $num -le $sbjcount; $num++) {
        $cnt++
        Write-Host "$sbj $cnt Number:$num"
        $svcname = "iNVATRON $app 1 $cnt"
        if ($svcname -in $svclist) {continue}
        
        & C:\Periscope\bin\$($app).exe -s install -S $sbj $cnt
        & C:\Periscope\bin\$($app).exe -s start $cnt
    }
    return $cnt
}

$cnt = 0
foreach ($s in $subs) {
    Write-Host "Installing $($s)"
    $cnt = Install-PeriApp $s $cnt "Periscope"
}

$cnt = 0
Write-Host "Installing FCST:$($DSS2_count)"
$cnt = Install-PeriApp "FCST:$($DSS2_count)" $cnt "PeriscopeDSS2"

$cnt = 0
Write-Host "Installing TRAX:$($TRAX_count)"
$cnt = Install-PeriApp "TRAX:$($TRAX_count)" $cnt "FreshTrax"

mkdir "C:\Periscope\log\termination\" -Force
Set-Location C:\Periscope
Remove-Item call-termination-endpoint.ps1 -ErrorAction Ignore
Set-Content C:\Periscope\call-termination-endpoint.ps1 @'
$currentDate = (Get-Date).ToString("MM-dd-yyyy HH:mm:ss")
$loglocation = "C:\Periscope\log\termination\call-termination-endpoint.log" 
$metadata = (Invoke-WebRequest -Uri "http://169.254.169.254/metadata/instance?api-version=2020-09-01" -Headers @{"Metadata" = "true"} -UseBasicParsing).Content
$response = (Invoke-WebRequest -Uri "http://169.254.169.254/metadata/scheduledevents?api-version=2019-01-01" -Headers @{"Metadata" = "true"} -UseBasicParsing ).Content
$instancename = ($metadata | ConvertFrom-Json).compute.name
$psresponse = $response | ConvertFrom-Json | ?{$_.Events.Resources -contains $instancename}
$instanceresp= $psresponse.Events | ?{$_.Resources -Contains $instancename}
if ($instanceresp.EventType -eq "Terminate") { C:\Windows\System32\GroupPolicy\Machine\Scripts\Shutdown\StopPeriscope.bat;
Write-Output "Terminating at $currentdate" >> $loglocation 
Write-Output "Services still running:" >> $loglocation
$services = (Get-Service | ?{$_.Name -like "*Periscope*1*" -and $_.Status -eq "Running"} | select Name).name
Write-Output $services >> $loglocation  
if ($services.count -eq 0 ) {
Write-Output "Cleanup complete. Shutting down..." >> $loglocation
$body = @{"StartRequests" = (,@{"EventId" = "$($instanceresp.EventId)"})} | ConvertTo-Json
Invoke-WebRequest -Uri "http://169.254.169.254/metadata/scheduledevents?api-version=2019-01-01" -Headers @{"Metadata" = "true"} -UseBasicParsing -Method POST -Body $body}}
else {Write-Output "No termination event at $currentDate" >> $loglocation }
'@

schtasks /create /tn callTermApiEndpoint /tr "powershell -NoLogo -WindowStyle hidden -file C:\Periscope\call-termination-endpoint.ps1" /sc minute /mo 5 /ru System /f

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
$acl.SetAccessRuleProtection($true,$true)
$acl | Set-Acl -Path "C:\Periscope"

#Remove modify rights from Authenticated Users
$acl = Get-Acl -Path "C:\Periscope"
$identity = "NT AUTHORITY\Authenticated Users"
$rule = $acl.Access | Where { $_.IdentityReference -eq $identity -and $_.FileSystemRights -like '*Modify*'  }
$acl.RemoveAccessRule($rule)
$acl | Set-Acl -Path "C:\Periscope"

#Remove special permissions from Authenticated Users, must be in separate step to work
$acl = Get-Acl -Path "C:\Periscope"
$rule = $acl.Access | Where { $_.IdentityReference -eq $identity  }
$acl.RemoveAccessRule($rule)
$acl | Set-Acl -Path "C:\Periscope"

# Download batch script files template
az storage blob download-batch --account-name $storageaccount  --container-name $containername --pattern  -d "C:\temp" --auth-mode login

# Batch script files template
$periscopeCnt = 0
foreach ($subjectWithCount in $subs) {
  $subjectWithCountObject = $subjectWithCount | ConvertFrom-String -PropertyNames Subject, Count -Delimiter ":"
  $periscopeCnt = $periscopeCnt + $subjectWithCountObject.Count
}

$startPeriscopeBat=$(Get-Content -Path C:\Periscope\StartPeriscope.bat)
$startPeriscopeBat = $startPeriscopeBat.Replace("[PERISCOPE_CNT]","$periscopeCnt").Replace("[PERISCOPEDSS2_CNT]","$DSS2_count").Replace("[FRESHTRAX_CNT]","$TRAX_count")
Set-Content -Path C:\Periscope\StartPeriscope.bat -Value $startPeriscopeBat

$stopPeriscopeBat=$(Get-Content -Path C:\Periscope\StopPeriscope.bat)
$allServiceCnt = $periscopeCnt + $DSS2_count + $TRAX_count
$stopPeriscopeBat = $stopPeriscopeBat.Replace("[PERISCOPE_CNT]","$periscopeCnt").Replace("[PERISCOPEDSS2_CNT]","$DSS2_count").Replace("[FRESHTRAX_CNT]","$TRAX_count").Replace("[ALLSERVICE_CNT]","$allServiceCnt")
Set-Content -Path C:\Periscope\StopPeriscope.bat -Value $stopPeriscopeBat
Set-Content -Path C:\Windows\System32\GroupPolicy\Machine\Scripts\Shutdown\StopPeriscope.bat -Value $stopPeriscopeBat

Stop-Transcript

# Apply Domain join by rebooting the VM
Restart-Computer