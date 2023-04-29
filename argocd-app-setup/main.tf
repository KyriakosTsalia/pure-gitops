resource "kubernetes_manifest" "argocd-app" {
  manifest = {
    "apiVersion" : "argoproj.io/v1alpha1",
    "kind" : "Application",
    "metadata" : {
      "name" : "pod-info-app",
      "namespace" : "argocd"
    },
    "spec" : {
      "project" : "default",
      "source" : {
        "repoURL" : "https://gitlab.com/${var.manifest-repo-namespace}/${var.manifest-repo-project}",
        "path" : "./manifests",
        "targetRevision" : "HEAD"
      },
      "destination" : {
        "server" : "https://kubernetes.default.svc",
        "namespace" : "default"
      },
      "syncPolicy" : {
        "automated" : {
          "selfHeal" : true,
          "prune" : true
        }
      }
    }
  }
}

data "kubernetes_service" "argocd-lb" {
  metadata {
    name      = "argocd-1-server"
    namespace = "argocd"
  }
}

resource "gitlab_project_hook" "example" {
  project                 = "${var.manifest-repo-namespace}/${var.manifest-repo-project}"
  url                     = "https://${data.kubernetes_service.argocd-lb.status[0].load_balancer[0].ingress[0].hostname}/api/webhook"
  merge_requests_events   = true
  enable_ssl_verification = false
}

resource "gitlab_deploy_token" "argocd-repository" {
  project  = "${var.manifest-repo-namespace}/${var.manifest-repo-project}"
  name     = "ArgoCD repository token"
  username = "argocd-token"

  scopes = ["read_repository"]
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
      "url" : base64encode("https://gitlab.com/${var.manifest-repo-namespace}/${var.manifest-repo-project}.git"),
      "password" : base64encode(gitlab_deploy_token.argocd-repository.token),
      "username" : base64encode(gitlab_deploy_token.argocd-repository.username),
    }
  }
}

resource "gitlab_deploy_token" "argocd-registry" {
  project  = "${var.app-repo-namespace}/${var.app-repo-project}"
  name     = "ArgoCD registry token"
  username = "argocd-token"

  scopes = ["read_registry"]
}

locals {
  email    = var.app-repo-user-email
  username = gitlab_deploy_token.argocd-registry.username
  password = gitlab_deploy_token.argocd-registry.token
  auth     = base64encode("${gitlab_deploy_token.argocd-registry.username}:${gitlab_deploy_token.argocd-registry.token}")
}

locals {
  dockerconfigjson = <<EOT
  {
      "auths": {
          "https://registry.gitlab.com":{
              "username":"${local.username}",
              "password":"${local.password}",
              "email":"${local.email}",
              "auth":"${local.auth}"
      	  }
      }
  }
  EOT
}

resource "kubernetes_manifest" "repo-credentials" {
  manifest = {
    "apiVersion" : "v1",
    "kind" : "Secret",
    "metadata" : {
      "name" : "gitlab-registry-credentials",
      "namespace" : "default"
    },
    "type" : "kubernetes.io/dockerconfigjson",
    "data" : {
      ".dockerconfigjson" : base64encode(local.dockerconfigjson)
    }
  }
}