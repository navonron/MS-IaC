terraform {
  required_providers {
    azapi = {
      source = "Azure/azapi"
      version = "2.1.0"
    }
  }
}

provider "azapi" {}