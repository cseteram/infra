resource "helm_release" "ingress_nginx" {
  name      = "ingress-nginx-real"
  namespace = "kube-system"

  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.3.0"

  values = [
    file("helm/ingress-nginx.yaml")
  ]
}

resource "helm_release" "cert_manager" {
  name      = "cert-manager"
  namespace = "kube-system"

  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "1.9.1"

  set {
    name  = "installCRDs"
    value = "true"
  }
}

resource "helm_release" "openebs_localpv_provisioner" {
  name      = "localpv-provisioner"
  namespace = "kube-system"

  repository = "https://openebs.github.io/dynamic-localpv-provisioner"
  chart      = "localpv-provisioner"
  version    = "3.3.0"

  set {
    name  = "hostpathClass.isDefaultClass"
    value = "true"
  }
}
