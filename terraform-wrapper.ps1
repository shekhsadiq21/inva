######## terraform-wrapper.ps1
#### use with any of these arguments
#### - init
#### - plan
#### - apply
#### - planApply
#### - destroy

$command = $args[0]

## initialize against the remote state in the shared services subscription
function Invoke-TerraformInit() {
    Write-Output "`n### TERRAFORM INIT"
    terraform init `
        -backend-config="storage_account_name=invatrontfstatess" `
        -backend-config="container_name=tfstate" `
        -backend-config="access_key=$($env:saAccessKey)" `
        -backend-config="key=dev$($env:prefix)-tf-state-file" `
        -reconfigure -upgrade
    if ($LastExitCode -ne 0) {
        throw "Terraform init failed"
    }
}

## run tf plan against the dev-template with your unique prefix
function Invoke-TerraformPlan() {
    Write-Output "`n### TERRAFORM PLAN"
    terraform plan `
        -out="out.plan" `
        -var-file="..\tf-periscope-infra-config\commons.tfvars" `
        -var-file="..\tf-periscope-infra-config\$($env:prefix)\$($env:prefix)-dev.tfvars" `
        -var "resource_prefix=$($env:prefix)" `
        -var config_atjobs_folder="../tf-periscope-infra-config/$($env:prefix)/ATJobs" `
        -var config_web_folder="../tf-periscope-infra-config/$($env:prefix)/Web" `
        -var app_image_version=$(${env:vm_image_version}) `
        -var web_image_version=$(${env:vm_image_version}) `
        -var mq_image_version=$(${env:vm_image_version}) `
        -var datadog_api_key=$env:DD_API_KEY `
        -var datadog_app_key=$env:DD_APP_KEY `
        -var pagerduty_token=$env:PAGERDUTY_TOKEN
    if ($LastExitCode -ne 0) {
        throw "Terraform plan failed"
    }
}

## run tf plan against the dev-template with your unique prefix and applies the plan after confirmation
function Invoke-TerraformPlanApply() {
    Write-Output "`n### TERRAFORM PLAN/APPLY"
    terraform apply `
        -var-file="..\tf-periscope-infra-config\commons.tfvars" `
        -var-file="..\tf-periscope-infra-config\$($env:prefix)\$($env:prefix)-dev.tfvars" `
        -var "resource_prefix=$($env:prefix)" `
        -var config_atjobs_folder="../tf-periscope-infra-config/$($env:prefix)/ATJobs" `
        -var config_web_folder="../tf-periscope-infra-config/$($env:prefix)/Web" `
        -var app_image_version=$(${env:vm_image_version}) `
        -var web_image_version=$(${env:vm_image_version}) `
        -var mq_image_version=$(${env:vm_image_version}) `
        -var datadog_api_key=$env:DD_API_KEY `
        -var datadog_app_key=$env:DD_APP_KEY `
        -var pagerduty_token=$env:PAGERDUTY_TOKEN
    if ($LastExitCode -ne 0) {
        throw "Terraform apply failed"
    }
}

# applies the plan output from plan command, with out.plan file
function Invoke-TerraformApply() {
    Write-Output "`n### TERRAFORM APPLY"
    terraform apply  out.plan
    if ($LastExitCode -ne 0) {
        throw "Terraform apply failed"
    }
}

function Invoke-TerraformDestroy() {
    Write-Output "`n### TERRAFORM DESTROY"
    terraform destroy `
        -var-file="..\tf-periscope-infra-config\commons.tfvars" `
        -var-file="..\tf-periscope-infra-config\$($env:prefix)\$($env:prefix)-dev.tfvars" `
        -var "resource_prefix=$($env:prefix)" `
        -var config_atjobs_folder="../tf-periscope-infra-config/$($env:prefix)/ATJobs" `
        -var config_web_folder="../tf-periscope-infra-config/$($env:prefix)/Web" `
        -var app_image_version=$(${env:vm_image_version}) `
        -var web_image_version=$(${env:vm_image_version}) `
        -var mq_image_version=$(${env:vm_image_version}) `
        -var datadog_api_key=$env:DD_API_KEY `
        -var datadog_app_key=$env:DD_APP_KEY `
        -var pagerduty_token=$env:PAGERDUTY_TOKEN
    if ($LastExitCode -ne 0) {
        throw "Terraform destroy failed"
    }
}

######################

$ErrorActionPreference = "Stop"

$startTime = Get-Date

Switch ($command) {
    "init" { Invoke-TerraformInit }
    "plan" { Invoke-TerraformPlan }
    "apply" { Invoke-TerraformApply }
    "planApply" { Invoke-TerraformPlanApply }
    "destroy" { Invoke-TerraformDestroy }
}

$endTime = Get-Date
$duration = New-TimeSpan -Start $startTime -End $endTime
Write-Host "Done!"
Write-Host "Duration: $duration"