param (
    $MQ_IP,
    $storageaccount,
    $containername,
    $ad_pass
)  

Start-Transcript c:\mq-vm-config.ps1.log

Add-MpPreference -ExclusionPath "C:\Periscope\log" -Force -ErrorAction Stop
Add-MpPreference -ExclusionPath "C:\Periscope\bin\RRA\Data\Log" -Force -ErrorAction Stop
Add-MpPreference -ExclusionPath "F:\Periscope\log" -Force -ErrorAction Stop

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
  Write-Host "Error joining domain. This is expected if the VM has already been joined."\
  Write-Host "Error: $_"
}

$disk = Get-Disk | Where partitionstyle -eq 'raw' | sort number

$driveLetter = "F"
if ($disk -ne $null) {
$disk |
Initialize-Disk -PartitionStyle MBR -PassThru |
New-Partition -UseMaximumSize -DriveLetter $driveLetter |
Format-Volume -FileSystem NTFS -NewFileSystemLabel "Periscope" -Confirm:$false -Force
}

mkdir F:\Periscope\dat -force
mkdir F:\Periscope\log -force
rm F:\Periscope\dat\IpRestrict.txt -ErrorAction SilentlyContinue
[System.IO.File]::WriteAllLines("F:\Periscope\dat\IpRestrict.txt", '*.*.*.*: *')

C:\Periscope\bin\proxy.exe -s Restart
C:\Periscope\bin\MQ.exe -s Restart

mkdir C:\Periscope\ATJobs -force
rm C:\Periscope\ATJobs\ATjobconfig.ps1 -ErrorAction SilentlyContinue
"cd C:\Periscope\ATJobs" >> C:\Periscope\ATJobs\ATjobconfig.ps1
"`$currentlist = gci -name -filter *.bat" >> C:\Periscope\ATJobs\ATjobconfig.ps1
"rm *.bat, *.pscript" >> C:\Periscope\ATJobs\ATjobconfig.ps1
"`$storageaccount = '$($storageaccount)'" >> C:\Periscope\ATJobs\ATjobconfig.ps1
"`$containername = '$($containername)'" >> C:\Periscope\ATJobs\ATjobconfig.ps1
'az login --identity' >> C:\Periscope\ATJobs\ATjobconfig.ps1
'az storage blob download-batch --account-name $storageaccount -s $containername -d "C:\Periscope" --auth-mode login --pattern "ATJobs/*"' >> C:\Periscope\ATJobs\ATjobconfig.ps1
'$newlist = gci -name -filter *.bat'  >> C:\Periscope\ATJobs\ATjobconfig.ps1
'if($newlist.count -lt $currentlist.count) { C:\Periscope\bin\DeleteATJobs.bat }'  >> C:\Periscope\ATJobs\ATjobconfig.ps1
'Get-ChildItem "C:\Periscope\ATJobs" | Where { $_.Name -like "*.bat"} | ForEach { cmd.exe /c $_.FullName }' >> C:\Periscope\ATJobs\ATjobconfig.ps1

schtasks /create /tn configATJobs /tr "powershell -NoLogo -WindowStyle hidden -file C:\Periscope\ATJobs\ATjobconfig.ps1" /sc minute /mo 60 /ru System /f

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

Stop-Transcript

# Apply Domain join by rebooting the VM
Restart-Computer