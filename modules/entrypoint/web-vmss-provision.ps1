$ErrorActionPreference = "Stop"

$tfSpSecret = ConvertTo-SecureString -String $env:ARM_CLIENT_SECRET -AsPlainText -Force
$tfSpCred = New-Object System.Management.Automation.PSCredential($env:ARM_CLIENT_ID , $tfSpSecret)

Connect-AzAccount -Credential $tfSpCred -TenantId $env:ARM_TENANT_ID -ServicePrincipal 
Set-AzContext -Subscription $env:ARM_SUBSCRIPTION_ID

$VMScaleSet = Get-AzVmss -ResourceGroupName "${resourceGroupName}" -VMScaleSetName "${virtualMachineScaleSetName}"

Add-AzVmssExtension `
  -VirtualMachineScaleSet $VMScaleSet `
  -Name "ApplicationHealthWindows" `
  -Publisher "Microsoft.ManagedServices" `
  -Type "ApplicationHealthWindows" `
  -TypeHandlerVersion "1.0" `
  -AutoUpgradeMinorVersion $true `
  -Setting @{"protocol" = "https"; "port" = 443; "requestPath" = "/periscope/"}

Add-AzVmssExtension `
  -VirtualMachineScaleSet $VMScaleSet `
  -Name "web-MMAgent" `
  -Publisher "Microsoft.EnterpriseCloud.Monitoring" `
  -Type "MicrosoftMonitoringAgent" `
  -TypeHandlerVersion "1.0" `
  -Setting @{"workspaceId" = "${workspaceId}"} `
  -ProtectedSetting @{"workspaceKey" = "${workspaceKey}"}

$vaultConfigSettings = @{
  secretsManagementSettings = @{
    pollingIntervalInS = "3600"
    certificateStoreName = "MY"
    linkOnRenewal = $true
    certificateStoreLocation = "LocalMachine"
    requireInitialSync = $false
    observedCertificates = @("${sslUrl}")
    authenticationSettings = @{
      msiEndpoint = "http://169.254.169.254/metadata/identity"
      msiClientId = "${vmIdentityClientId}"
    }
  }
}

Add-AzVmssExtension `
  -VirtualMachineScaleSet $VMScaleSet `
  -Name "VaultConfig" `
  -Publisher "Microsoft.Azure.KeyVault" `
  -Type "KeyVaultForWindows" `
  -TypeHandlerVersion "1.0" `
  -AutoUpgradeMinorVersion $true `
  -Setting $vaultConfigSettings

$webConfigSettings = @{
  fileUris = @("${webConfigBlobUrl}")
  commandToExecute = "${webConfigCommand}"
  managedIdentity = @{
    clientId = "${vmIdentityClientId}"
  }
}

Add-AzVmssExtension `
  -VirtualMachineScaleSet $VMScaleSet `
  -Name "WebConfig" `
  -Publisher "Microsoft.Compute" `
  -Type "CustomScriptExtension" `
  -TypeHandlerVersion "1.0" `
  -AutoUpgradeMinorVersion $true `
  -ForceUpdateTag "${webConfigForceUpdateTag}" `
  -ProtectedSetting $webConfigSettings

Update-AzVmss `
  -ResourceGroupName "${resourceGroupName}" `
  -VMScaleSetName "${virtualMachineScaleSetName}" `
  -VirtualMachineScaleSet $VMScaleSet `
  -EnableAutomaticRepair $true `
  -AutomaticRepairGracePeriod "PT10M"