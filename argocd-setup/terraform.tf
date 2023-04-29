terraform {
  required_version = "~>1.4.4"
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~>2.9.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.20.0"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = "~>0.44.1"
    }
  }
}

variable "ORG_NAME" {
  type        = string
  description = "Your organization's name."
}

data "tfe_outputs" "eks" {
  organization = var.ORG_NAME
  workspace    = "eks"
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

