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

resource "gitlab_project_hook" "example" {
  project               = "kyriakos_tsalia/pure-gitops"
  url                   = "https://ad1a0f04350ea49c1beffcb2542c4a35-1068545409.eu-central-1.elb.amazonaws.com/api/webhook"
  merge_requests_events = true
  enable_ssl_verification = false
}

resource "kubernetes_manifest" "private-repo-connection" {
  manifest = {
    "apiVersion" : "v1",
    "kind" : "Secret",
    "metadata" : {
      "name" : "my-private-https-repo",
      "namespace" : "argocd",
      "labels" : {
        "argocd.argoproj.io/secret-type" : "repository"
      }
    },
    "data" : {
      "url" : base64encode("https://gitlab.com/kyriakos_tsalia/pure-gitops.git"),
      "password" : base64encode(gitlab_deploy_token.argocd.token),
      "username" : base64encode(gitlab_deploy_token.argocd.username),
    }
  }
}