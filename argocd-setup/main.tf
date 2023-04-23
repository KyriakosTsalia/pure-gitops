resource "helm_release" "argocd" {
  name       = "argocd-1"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "5.29.1"

  namespace        = "argocd"
  create_namespace = true

  set {
    name  = "server.service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "controller.args.appResyncPeriod"
    value = "60"
  }
}

resource "gitlab_deploy_token" "argocd" {
  project  = "kyriakos_tsalia/pure-gitops"
  name     = "ArgoCD deploy token"
  username = "argocd-token"

  scopes = ["read_repository"]
}

# resource "kubernetes_manifest" "private-repo-connection" {
#   manifest = {
#     "apiVersion" : "v1",
#     "kind" : "Secret",
#     "metadata" : {
#       "name" : "my-private-https-repo",
#       "namespace" : "argocd",
#       "labels" : {
#         "argocd.argoproj.io/secret-type" : "repository"
#       }
#     },
#     "stringData" : {
#       "url" : "https://gitlab.com/kyriakos_tsalia/pure-gitops",
#       "password" : gitlab_deploy_token.argocd.token,
#       "username" : gitlab_deploy_token.argocd.username,
#     }
#   }
# }