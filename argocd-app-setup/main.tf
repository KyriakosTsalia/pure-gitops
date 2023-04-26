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