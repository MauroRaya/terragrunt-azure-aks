locals {
  _root         = read_terragrunt_config(find_in_parent_folders("root.hcl"))
  _environment  = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
  _location     = read_terragrunt_config(find_in_parent_folders("location.hcl"))

  username        = local._root.locals.terraform_source_github_username
  repository_name = local._root.locals.terraform_source_github_repository_name

  environment = local._environment.locals.environment
  location    = local._location.locals.location
}

terraform {
  source = "git::https://github.com/${local.username}/${local.repository_name}//network-security-group?ref=main"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependency "rg" {
  config_path = "../../resource-group/rg-aks-dev"
}

inputs = {
  name                = "nsg-aks-${local.environment}"
  location            = local.location
  resource_group_name = dependency.rg.outputs.name
}