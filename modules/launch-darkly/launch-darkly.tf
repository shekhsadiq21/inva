terraform {
  required_providers {
    launchdarkly = {
      source  = "launchdarkly/launchdarkly"
      version = "~> 2.0"
    }
  }
}

resource "random_shuffle" "random_hex_color" {
  input        = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F"]
  result_count = 6
}

# Can be of value: int,dmo,uat,dev,prd. These are created in tf-sharedservices-infra
data "launchdarkly_environment" "environments" {
  key         = var.env
  project_key = "default"
}
