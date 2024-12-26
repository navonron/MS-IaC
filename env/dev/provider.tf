terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.14.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
  backend "azurerm" {
    use_oidc             = true
    subscription_id      = var.subscription_id
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}
