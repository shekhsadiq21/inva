terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.6.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
    null-resource = {
      source  = "hashicorp/null"
      version = "3.1.0"
    }
    datadog = {
      source  = "datadog/datadog"
      version = "3.2.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.7.2"
    }
    launchdarkly = {
      source  = "launchdarkly/launchdarkly"
      version = "~> 2.0"
    }
    pagerduty = {
      source  = "PagerDuty/pagerduty"
      version = "1.9.9"
    }
  }
  backend "azurerm" {
    resource_group_name  = "ss-infra"
    storage_account_name = "invatrontfstatess"
    container_name       = "tfstate"
    key                  = ""
    access_key           = ""
  }
}

provider "azurerm" {
  features {}
}

# Both providers below will use the same credentials from the azurerm provider above
# ex. if sbx-tf-sp is used to connect to Inv-Sandbox-Dev as the default subscription, 
# it will be used to connect to the other subscriptions below as well.

provider "azurerm" {
  features {}

  alias           = "shared"
  subscription_id = "4d56129a-2078-4899-8e93-e3fc3ae74e0b" # Inv-Shared-Services subscription
}

provider "azurerm" {
  features {}

  alias           = "analytics"
  subscription_id = "7e35a866-3bd5-46f7-a652-48cc1e2e3e13" # Inv-Sandbox-Dev subscription, where analytics ptf is currently deployed
}
