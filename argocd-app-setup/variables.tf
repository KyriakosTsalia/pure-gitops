variable "gitlab_auth_token" {
  type        = string
  description = "OAuth token supplied by the VCS provider."
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

variable "manifest-repo-namespace" {
  type        = string
  description = "The namespace where the manifest repository belongs."
}

variable "manifest-repo-project" {
  type        = string
  description = "The name of the manifest repository project."
}