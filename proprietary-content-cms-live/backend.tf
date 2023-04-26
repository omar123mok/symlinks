terraform {
  backend "s3" {
    bucket               = "eis-shared-services-terraform-state"
    key                  = "infrastructure/proprietary-content-cms-live.tfstate"
    region               = "us-east-1"
    encrypt              = true
    dynamodb_table       = "eis-shared-services-terraform-state"
    workspace_key_prefix = "workspaces"
  }
}
