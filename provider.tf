variable "account-id" {
  default = null
}

variable "initial-region" {
  default = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.9"
    }
  }
}

provider "aws" {
  region = var.initial-region
  assume_role {
    role_arn = var.account-id != null ? "arn:aws:iam::${var.account-id}:role/automation/atlantis" : null
  }
}