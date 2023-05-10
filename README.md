# tf-periscope-infra

This repository is currently used to define all Terraform cloud resources and configurations to deploy Periscope on Azure.

# Local Deployment Procedure

## Requirements

* Azure CLI: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli
* Terraform 1.1.3: https://releases.hashicorp.com/terraform/1.1.3/
* PowerShell SqlServer, Azure, AzTable modules:
```powershell
Install-PackageProvider -Name NuGet -Force
Register-PSRepository -Default -InstallationPolicy Trusted
Install-Module SqlServer,AzTable,Az -Repository PSGallery -Scope CurrentUser
```
* PowerShell Core: https://github.com/PowerShell/PowerShell/releases

## Environment variables

Fetch environment variables from 1Password: https://start.1password.com/open/i?a=HVZDH7QNONGMNNZBP3Z3K7F5ZM&h=invafresh.1password.com&i=i3ltu3kzfd6seilqgf663vmcnu&v=k2npdiq63ti6kyzmm4aklcagdu

These environment variables need to be set prior to running Terraform locally:
* `vm_image_version` : the Periscope VM image version to apply (ex. 1.2.54)
* `prefix`: your own 3 letter prefix, example: mbe for Michael Bertoni, must be unique
* `saAccessKey`: invatrontfstatess storage account admin key
* `ARM_SUBSCRIPTION_ID`: Inv-Sandbox-Dev subscription ID
* `ARM_CLIENT_ID`: Service principal ID used for terraform deployment
* `ARM_CLIENT_SECRET`: its secret
* `ARM_TENANT_ID`: Tenant ID of our Azure organization
* `DD_API_KEY`: Datadog API key
* `DD_APP_KEY`: Datadog Application key
* `PAGERDUTY_TOKEN`: Pagerduty API token

## Setup your development terraform variable template

Clone the `environment-config` repository in the parent directory of this repo. ([link](https://dev.azure.com/invatron/tf-periscope-infra/_git/environment-config))

Create/update your own folder prefix (for example, mbe folder for Michael Bertoni, nab for Nicholas Bagnato).

Following changes need to be applied in your $prefix-dev.tfvars file at the root of your prefix folder.

Edit the following fields:
* `is_esha_deployed` and variables below it if you need to deploy ESHA (Caveat: ESHA VM provisioning happens in this pipeline: https://dev.azure.com/invatron/tf-periscope-infra/_build?definitionId=23)
* `common_tags`: `Owner`, `Created By`, `Customer` fields in particular

CIDRs to be set:
* `main_address_space`
* `app_gw_subnet`     
* `vmss_subnet`       
* `data_address_space`
* `redis_subnet`      
* `data_subnet`       

To setup these CIDRs, you have to run the ipam.ps1 script in scripts folder
```powershell
Connect-AzAccount -Subscription "Inv-Shared-Services"
.\scripts\ipam.ps1 mbe dev # dev being the environment code and mbe being your personal prefix
```

The script will produce a `network.auto.tfvars` file output that will be picked up by Terraform during your next plan.

The script will either read the current address space for you environment, or create a new one.

## Run terraform locally

You can either use raw `terraform` commands or use the `terraform-wrapper.ps1` script.

Keep in mind you have to have use .tfvars variable files from the `environment-config` repository in order to deploy 
your environment with Terraform.

Fortunately, the `terrafors-wrapper.ps1` file takes care of that, as long as you prepared your environment variables 
correctly. Note that it will only deploy dev type environments.

The wrapper can be use with these arguments:
- `init`: terraform init
- `plan`: terraform plan, outputs plan.out file
- `apply`: terraform apply, applies plan.out file
- `planApply`: terraform plan and apply in one command
- `destroy`: terraform destroy, asks for confirmation