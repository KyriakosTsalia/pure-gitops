terraform {
  required_version = "~>1.4.4"
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~>2.9.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~>2.20.0"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = "~>0.44.1"
    }
  }
}

data "tfe_outputs" "eks" {
  organization = "GitOps-Organization"
  workspace    = "eks"
}

