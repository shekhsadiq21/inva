$ErrorActionPreference = "Stop"

if (Get-Module -ListAvailable -Name SqlServer) {
    Write-Host "SqlServer Module exists, proceeding"
} 
else {
    Throw "SqlServer Module is not installed"
}

Set-Location modules/dbs/sql

$tfSpSecret = ConvertTo-SecureString -String $env:ARM_CLIENT_SECRET -AsPlainText -Force
$tfSpCred = New-Object System.Management.Automation.PSCredential($env:ARM_CLIENT_ID , $tfSpSecret)

Connect-AzAccount -Credential $tfSpCred -TenantId $env:ARM_TENANT_ID -ServicePrincipal 
Set-AzContext -Subscription ${deployment_sub}

$httpRes = (Invoke-WebRequest -uri "http://checkip.dyndns.com/").Content
$agentIP = ($httpRes  |  Select-String -Pattern "\d{1,3}(\.\d{1,3}){3}" -AllMatches).Matches.Value
Write-Host "Agent IP: $agentIP"

Set-AzSqlServer `
  -ServerName "${sql_server_name}" `
  -ResourceGroupName "${resource_group_name}" `
  -PublicNetworkAccess "Enabled"

New-AzSqlServerFirewallRule `
  -ResourceGroupName "${resource_group_name}" `
  -ServerName "${sql_server_name}" `
  -FirewallRuleName "esha_change" `
  -StartIpAddress "$agentIP" `
  -EndIpAddress "$agentIP"

$azStorageAccount = New-AzStorageContext `
  -StorageAccountName "eshabackupinvaprodeastus" `
  -StorageAccountKey "${esha_db_backup_storage_account_admin_key}"

Get-AzStorageBlobContent `
  -Context $azStorageAccount `
  -Container "esha-backup" `
  -Blob "Gendata.bacpac" `
  -Force

sqlpackage /SourceFile:"Gendata.bacpac" /Action:Import /TargetServerName:"${sql_server_fqdn}" `
  /TargetDatabaseName:"${esha_db_name}" /TargetUser:"${sql_server_user}" /TargetPassword:"${db_pass}"
if ($LastExitCode -ne 0) {
  throw "sqlpackage failed"
}

Remove-Item Gendata.bacpac

# this is not working for now: https://dev.azure.com/invatron/tf-periscope-infra/_build/results?buildId=2994&view=logs&j=c970d263-77bb-52d7-1861-5b2637d7126d&t=9a531be0-efc8-53d6-7698-13ae053bbb14
# sqlcmd -U aaddcdevops@invafresh.com -P ${ad_db_pass} -S ${sql_server_fqdn} -d ${esha_db_name} -G -i "./AzureADUsers.sql" -v adgroup=${adgroup}
# if ($LastExitCode -ne 0) {
#   throw "sqlcmd AzureADUsers.sql failed"
# }

$eshaConnectionString = "Data Source='${sql_server_fqdn}';database='${esha_db_name}';User ID='${sql_server_user}';Password='${db_pass}'"
$eshaSqlCmdVariables = 'esha_customer_number=${esha_customer_number}', 'esha_port_sql_serial_key=${esha_port_sql_serial_key}', 'esha_genesis_serial_key=${esha_genesis_serial_key}'
Invoke-Sqlcmd -ConnectionString $eshaConnectionString -Variable $eshaSqlCmdVariables -InputFile "./EshaClean.sql"

Remove-AzSqlServerFirewallRule `
  -ResourceGroupName "${resource_group_name}" `
  -ServerName "${sql_server_name}" `
  -FirewallRuleName "esha_change"

Set-AzSqlServer `
  -ServerName "${sql_server_name}" `
  -ResourceGroupName "${resource_group_name}" `
  -PublicNetworkAccess "Disabled"

Set-AzSqlDatabase `
  -ServerName "${sql_server_name}" `
  -ResourceGroupName "${resource_group_name}" `
  -DatabaseName "${esha_db_name}" `
  -Edition "GeneralPurpose" `
  -Family "Gen5" `
  -Capacity ${esha_db_core_count}
