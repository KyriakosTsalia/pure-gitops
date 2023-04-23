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

output "eks-cluster-endpoint" {
  value = data.tfe_outputs.eks.values.cluster_endpoint
  sensitive = true
}

# provider "helm" {
#   kubernetes {
#     host                   = data.tfe_outputs.eks.cluster_endpoint
#     cluster_ca_certificate = base64decode(data.tfe_outputs.eks.cluster_ca_cert_data)
#     exec {
#       api_version = "client.authentication.k8s.io/v1beta1"
#       args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
#       command     = "aws"
#     }
#   }
# }

# provider "kubernetes" {
#   host                   = data.tfe_outputs.eks.cluster_endpoint
#   cluster_ca_certificate = base64decode(data.tfe_outputs.eks.cluster_ca_cert_data)
#   exec {
#     api_version = "client.authentication.k8s.io/v1beta1"
#     args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
#     command     = "aws"
#   }
# }

# resource "kubernetes_namespace" "namespace_argocd" {
#   metadata {
#     name = var.argocd_k8s_namespace
#   }
# }