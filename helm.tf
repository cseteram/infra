resource "helm_release" "ingress_nginx" {
  name      = "ingress-nginx-real"
  namespace = "kube-system"

  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.3.0"

  set {
    name  = "controller.service.type"
    value = "NodePort"
  }

  set {
    name  = "controller.service.nodePorts.http"
    value = "30080"
  }

  set {
    name  = "controller.service.nodePorts.https"
    value = "30443"
  }

  set {
    name  = "controller.publishService.enabled"
    value = "false"
  }

  set {
    name  = "controller.extraArgs.publish-status-address"
    value = "sekai.cseteram.dev"
  }
}
