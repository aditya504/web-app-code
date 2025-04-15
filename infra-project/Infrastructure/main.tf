terraform {
  required_version = ">= 1.1.0"
  backend "azurerm" {}
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

locals {
  modules = toset(var.modules)
}

module "resource_group" {
  count    = contains(local.modules, "resource_group") ? 1 : 0
  source   = "git::https://github.com/aditya504/testing_terraform_code.git//resource_group"
  name     = "rg-demo-${var.env}"
  location = "East US"
}

module "storage_account" {
  count               = contains(local.modules, "storage_account") ? 1 : 0
  source              = "git::https://github.com/aditya504/testing_terraform_code.git//storage_account"
  name                = "stgacct${var.env}"
  location            = "East US"
  resource_group_name = module.resource_group[0].name
}

module "app_service" {
  count               = contains(local.modules, "app_service") ? 1 : 0
  source              = "git::https://github.com/aditya504/testing_terraform_code.git//app_service"
  app_name            = "webapp-${var.env}"
  plan_name           = "appserviceplan-${var.env}"
  location            = "East US"
  resource_group_name = module.resource_group[0].name
}