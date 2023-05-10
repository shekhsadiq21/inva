param (
    $ad_pass
)  

Start-Transcript c:\esha-vm-config.ps1.log

Add-MpPreference -ExclusionPath "C:\Periscope\log" -Force -ErrorAction Stop
Add-MpPreference -ExclusionPath "C:\Periscope\bin\RRA\Data\Log" -Force -ErrorAction Stop

try {
  $Name = "invafreshds.com"
  $User = "aaddcdevops@invafreshds.com"
  $Restart = "true"
  $options = 3
  $OUPath = "OU=ESHA_AZVMs,DC=invafreshds,DC=com"
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

Stop-Transcript

# Apply Domain join by rebooting the VM
Restart-Computer