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
  -Setting @{"protocol" = "tcp"; "port" = 5803}

Add-AzVmssExtension `
  -VirtualMachineScaleSet $VMScaleSet `
  -Name "app-MMAgent" `
  -Publisher "Microsoft.EnterpriseCloud.Monitoring" `
  -Type "MicrosoftMonitoringAgent" `
  -TypeHandlerVersion "1.0" `
  -Setting @{"workspaceId" = "${workspaceId}"} `
  -ProtectedSetting @{"workspaceKey" = "${workspaceKey}"}

$appConfigSettings = @{
  fileUris = @("${appConfigBlobUrl}")
  commandToExecute = "${appConfigCommand}"
  managedIdentity = @{
    clientId = "${vmIdentityClientId}"
  }
}

Add-AzVmssExtension `
  -VirtualMachineScaleSet $VMScaleSet `
  -Name "appConfig" `
  -Publisher "Microsoft.Compute" `
  -Type "CustomScriptExtension" `
  -TypeHandlerVersion "1.0" `
  -AutoUpgradeMinorVersion $true `
  -ProtectedSetting $appConfigSettings

Update-AzVmss `
  -ResourceGroupName "${resourceGroupName}" `
  -VMScaleSetName "${virtualMachineScaleSetName}" `
  -VirtualMachineScaleSet $VMScaleSet `
  -EnableAutomaticRepair $true `
  -AutomaticRepairGracePeriod "PT10M"