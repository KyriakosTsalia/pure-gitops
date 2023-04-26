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
        "repoURL" : "https://gitlab.com/kyriakos_tsalia/pure-gitops",
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

resource "gitlab_deploy_token" "argocd" {
  project  = "kyriakos_tsalia/pod-info-app"
  name     = "ArgoCD registry token"
  username = "argocd-token"

  scopes = ["read_registry"]
}

locals {
  email    = var.app-repo-user-email
  username = gitlab_deploy_token.argocd.username
  password = gitlab_deploy_token.argocd.token
  auth     = base64encode("${gitlab_deploy_token.argocd.username}:${gitlab_deploy_token.argocd.token}")
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
      "name" : "gitlab-registry-credentials"
    },
    "type" : "kubernetes.io/dockerconfigjson",
    "data" : {
      ".dockerconfigjson" : base64encode(local.dockerconfigjson)
    }
  }
}