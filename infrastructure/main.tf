terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  required_version = ">= 1.1.0"
}

provider "aws" {
  profile = "default"
  region  = var.region
}

data "aws_caller_identity" "current" {}

locals {
  prefix     = var.project_name
  app_dir    = "/"
  account_id = data.aws_caller_identity.current.account_id
}

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  region = var.region
  global_tags = {
    "environment" = "${var.project_name}-vpn"
  }
  availability_zones = sort(data.aws_availability_zones.available.names)
}
