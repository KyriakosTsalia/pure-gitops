variable "AWS_DEFAULT_REGION" {
  type        = string
  description = "(Optional) The region where the aws resources will be created. Defaults to eu-central-1."
  default     = "eu-central-1"
}

variable "eks_cluster_name" {
    type = string
    description = "The name of your EKS cluster."
}