terraform {
  required_version = "~>1.4.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.64.0"
    }
  }
}

provider "aws" {}