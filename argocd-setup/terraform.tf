terraform {
  required_version = "~>1.4.4"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.64.0"
    }
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = "15.11.0"
    }
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

data "tfe_outputs" "eks" {
  organization = "GitOps-Organization"
  workspace    = "eks"
}

variable "gitlab_token" {
  type        = string
  description = "OAuth token supplied by the VCS provider."
}

# variable "AWS_DEFAULT_REGION" {
#   type        = string
#   description = "(Optional) The region where the aws resources will be created. Defaults to eu-central-1."
# }

provider "aws" {
  region = var.AWS_DEFAULT_REGION
}

provider "gitlab" {
  token = var.gitlab_token
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

provider "kubernetes" {
  host                   = data.tfe_outputs.eks.values.cluster_endpoint
  cluster_ca_certificate = base64decode(data.tfe_outputs.eks.values.cluster_ca_cert_data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", "cluster-1"]
    command     = "aws"
  }
}
