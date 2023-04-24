resource "kubernetes_manifest" "argocd-app" {
  manifest = {
    "apiVersion" : "argoproj.io/v1alpha1",
    "kind" : "Application",
    "metadata" : {
      "name" : "nginx-app",
      "namespace" : "argocd"
    },
    "spec" : {
      "project" : "default",
      "source" : {
        "repoURL" : "https://gitlab.com/kyriakos_tsalia/pure-gitops",
        "path" : "./app/manifests",
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