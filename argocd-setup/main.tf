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
  name     = "ArgoCD repository token"
  username = "argocd-token"

  scopes = ["read_repository"]
}

resource "terraform_data" "argocd-lb-delay" {
  triggers_replace = helm_release.argocd.id
  provisioner "local-exec" {
    command = "sleep 60"
  }
}

data "kubernetes_service" "argocd-lb" {
  metadata {
    name      = "argocd-1-server"
    namespace = "argocd"
  }
  depends_on = [terraform_data.argocd-lb-delay]
}

resource "gitlab_project_hook" "example" {
  project                 = "kyriakos_tsalia/pure-gitops"
  url                     = "https://${data.kubernetes_service.argocd-lb.status[0].load_balancer[0].ingress[0].hostname}/api/webhook"
  merge_requests_events   = true
  enable_ssl_verification = false
}

resource "kubernetes_manifest" "private-repo-connection" {
  manifest = {
    "apiVersion" : "v1",
    "kind" : "Secret",
    "metadata" : {
      "name" : "manifest-repo-connection",
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
  depends_on = [helm_release.argocd]
}

output "argocd-lb" {
  value = data.kubernetes_service.argocd-lb.status[0].load_balancer[0].ingress[0].hostname
}