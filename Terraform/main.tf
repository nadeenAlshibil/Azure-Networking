terraform {
  required_version = ">=1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.45.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
    tls = {
      source = "hashicorp/tls"
      version = "~>4.0"
    }
    http = {
      source = "hashicorp/http"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

data "azuread_client_config" "current" {}

resource "azurerm_resource_group" "default" {
  name     = "rg-${var.name}-${var.environment}"
  location = var.location
}

