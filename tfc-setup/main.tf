resource "tfe_organization" "gitops-org" {
  name  = var.org-name
  email = var.org-admin
}
resource "tfe_project" "gitops-eks" {
  organization = tfe_organization.gitops-org.name
  name         = var.project-name
}

resource "tfe_oauth_client" "gitlab-client" {
  name             = "gitlab-oauth-client"
  organization     = tfe_organization.gitops-org.name
  api_url          = "https://gitlab.com/api/v4"
  http_url         = "https://gitlab.com"
  oauth_token      = var.oauth-token // GitLab Personal Access Token
  service_provider = "gitlab_hosted"
}

resource "tfe_workspace" "eks" {
  name              = "eks"
  organization      = tfe_organization.gitops-org.name
  project_id        = tfe_project.gitops-eks.id
  terraform_version = "~>1.4.5"
  working_directory = "./eks-argocd"
  vcs_repo {
    identifier     = var.repo-identifier
    oauth_token_id = tfe_oauth_client.gitlab-client.oauth_token_id
  }
}

resource "tfe_variable" "aws-region" {
  key          = "AWS_DEFAULT_REGION"
  value        = var.AWS_DEFAULT_REGION
  category     = "env"
  workspace_id = tfe_workspace.eks.id
}

resource "tfe_variable" "aws-access-key" {
  key          = "AWS_ACCESS_KEY_ID"
  value        = var.AWS_ACCESS_KEY_ID
  category     = "env"
  workspace_id = tfe_workspace.eks.id
}

resource "tfe_variable" "aws-secret-key" {
  key          = "AWS_SECRET_ACCESS_KEY"
  value        = var.AWS_SECRET_ACCESS_KEY
  category     = "env"
  workspace_id = tfe_workspace.eks.id
  sensitive    = true
}