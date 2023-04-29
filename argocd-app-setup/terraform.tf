terraform {
  required_version = "~>1.4.4"
  required_providers {
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = "15.11.0"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = "~>0.44.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.20.0"
    }
  }
}

data "tfe_outputs" "eks" {
  organization = var.ORG_NAME
  workspace    = "eks"
}

provider "gitlab" {
  token = var.gitlab_auth_token
}

provider "kubernetes" {
  host                   = data.tfe_outputs.eks.values.cluster_endpoint
  cluster_ca_certificate = base64decode(data.tfe_outputs.eks.values.cluster_ca_cert_data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", "cluster-1"]
    command     = "aws"
  }
}