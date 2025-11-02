locals {
  subscription_id                         = get_env("SUBSCRIPTION_ID")
  terraform_source_github_username        = "MauroRaya"
  terraform_source_github_repository_name = "terraform-azure-modules"
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "azurerm" {
  features {}

  subscription_id = "${local.subscription_id}"
}
EOF
}

inputs = {
  tags = {
    Terraform     = true
    TerraformPath = path_relative_to_include()
  },
}

remote_state {
  backend = "local"

  config = {
    path = "${path_relative_to_include()}/terraform.tfstate"
  }

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

terraform_version_constraint  = ">= 1.10.3"
terragrunt_version_constraint = ">= 0.63.6"
