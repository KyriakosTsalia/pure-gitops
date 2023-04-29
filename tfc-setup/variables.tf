variable "org-name" {
  type        = string
  description = "Your TFC Organization's name."
}

variable "org-admin" {
  type        = string
  description = "Email address of your TFC Organization's admin."
}

variable "project-name" {
  type        = string
  description = "Name for a dedicated TFC Project."
}

variable "oauth-token" {
  type        = string
  description = "The token string you were given by your VCS provider."
}

variable "repo-identifier" {
  type        = string
  description = "A reference to your VCS repository in the format <vcs organization>/<repository>."
}

variable "AWS_ACCESS_KEY_ID" {
  type        = string
  description = "AWS access key - part of AWS credentials."
}

variable "AWS_SECRET_ACCESS_KEY" {
  type        = string
  description = "AWS secret access key - part of AWS credentials."
  sensitive   = true
}

variable "AWS_DEFAULT_REGION" {
  type        = string
  description = "(Optional) The region where the aws resources will be created. Defaults to eu-central-1."
  default     = "eu-central-1"
}

variable "eks_cluster_name" {
  type        = string
  description = "The name of your EKS cluster."
}

variable "app-repo-user-email" {
  type        = string
  description = "Your GitLab email."
}

variable "app-repo-namespace" {
  type        = string
  description = "The namespace where the application repository belongs."
}

variable "app-repo-project" {
  type        = string
  description = "The name of the application repository project."
}