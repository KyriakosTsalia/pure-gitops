terraform {
  required_version = "~>1.4.4"
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~>2.9.0"
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

provider "helm" {
  kubernetes {
    host                   = data.tfe_outputs.eks.values.cluster_endpoint
    cluster_ca_certificate = base64decode(data.tfe_outputs.eks.values.cluster_ca_cert_data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", "cluster-1"]
      command     = "aws"
    }
  }
}

