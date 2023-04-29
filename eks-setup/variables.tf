variable "AWS_DEFAULT_REGION" {
  type        = string
  description = "(Optional) The region where the aws resources will be created. Defaults to eu-central-1."
  default     = var.AWS_DEFAULT_REGION
}

variable "eks_cluster_name" {
  type        = string
  description = "The name of your EKS cluster."
}