terraform {
  required_version = "~>1.4.4"
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "~>0.44.1"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.64.0"
    }
  }
}

provider "aws" {
  region = var.AWS_DEFAULT_REGION
}