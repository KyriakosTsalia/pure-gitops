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

data "kubernetes_service" "argocd-lb" {
  metadata {
    name      = "argocd-1-server"
    namespace = "argocd"
  }
  depends_on = [helm_release.argocd]
}

output "argocd-lb" {
  value = data.kubernetes_service.argocd-lb.status[0].load_balancer[0].ingress[0].hostname
}