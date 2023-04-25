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
  name                      = "eks"
  organization              = tfe_organization.gitops-org.name
  project_id                = tfe_project.gitops-eks.id
  # remote_state_consumer_ids = [tfe_workspace.argocd.id, tfe_workspace.argocd-app.id]
  terraform_version         = "~>1.4.5"
  working_directory         = "./eks-setup"
  vcs_repo {
    identifier     = var.repo-identifier
    oauth_token_id = tfe_oauth_client.gitlab-client.oauth_token_id
  }
}

# resource "tfe_workspace" "argocd" {
#   name              = "argocd-installation"
#   organization      = tfe_organization.gitops-org.name
#   project_id        = tfe_project.gitops-eks.id
#   terraform_version = "~>1.4.5"
#   working_directory = "./argocd-setup"
#   vcs_repo {
#     identifier     = var.repo-identifier
#     oauth_token_id = tfe_oauth_client.gitlab-client.oauth_token_id
#   }
#   force_delete = true
# }

resource "tfe_workspace" "argocd-app" {
  name              = "argocd-app"
  organization      = tfe_organization.gitops-org.name
  project_id        = tfe_project.gitops-eks.id
  terraform_version = "~>1.4.5"
  working_directory = "./argocd-app-setup"
  vcs_repo {
    identifier     = var.repo-identifier
    oauth_token_id = tfe_oauth_client.gitlab-client.oauth_token_id
  }
}

# resource "tfe_run_trigger" "reinstall-argocd" {
#   workspace_id  = tfe_workspace.argocd.id
#   sourceable_id = tfe_workspace.eks.id
# }

resource "tfe_variable_set" "aws-creds" {
  name         = "AWS Credentials"
  description  = "Variable set applied to all workspaces."
  organization = tfe_organization.gitops-org.name
}

resource "tfe_project_variable_set" "gitops-eks" {
  variable_set_id = tfe_variable_set.aws-creds.id
  project_id      = tfe_project.gitops-eks.id
}

resource "tfe_variable" "aws-region" {
  key             = "AWS_DEFAULT_REGION"
  value           = var.AWS_DEFAULT_REGION
  category        = "env"
  variable_set_id = tfe_variable_set.aws-creds.id
}

resource "tfe_variable" "aws-access-key" {
  key             = "AWS_ACCESS_KEY_ID"
  value           = var.AWS_ACCESS_KEY_ID
  category        = "env"
  variable_set_id = tfe_variable_set.aws-creds.id
}

resource "tfe_variable" "aws-secret-key" {
  key             = "AWS_SECRET_ACCESS_KEY"
  value           = var.AWS_SECRET_ACCESS_KEY
  category        = "env"
  variable_set_id = tfe_variable_set.aws-creds.id
  sensitive       = true
}

resource "tfe_variable" "eks-cluster-name" {
  key          = "eks_cluster_name"
  value        = var.eks_cluster_name
  category     = "terraform"
  workspace_id = tfe_workspace.eks.id
}

# resource "tfe_variable" "gitlab-token" {
#   key          = "gitlab_token"
#   value        = var.oauth-token
#   category     = "terraform"
#   workspace_id = tfe_workspace.argocd.id
#   sensitive    = true
# }