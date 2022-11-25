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

resource "helm_release" "external_dns" {
  name      = "external-dns"
  namespace = "kube-system"

  repository = "https://kubernetes-sigs.github.io/external-dns"
  chart      = "external-dns"
  version    = "1.11.0"

  depends_on = [
    kubernetes_secret.external_dns
  ]

  values = [
    file("helm/external-dns.yaml")
  ]
}

resource "helm_release" "dashboard" {
  name      = "dashboard"
  namespace = kubernetes_namespace.dashboard.id

  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "42.0.2"

  values = [
    file("helm/kube-prometheus-stack.yaml")
  ]
}

resource "helm_release" "loki" {
  name      = "loki"
  namespace = kubernetes_namespace.dashboard.id

  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki-stack"
  version    = "2.8.7"

  set {
    name  = "loki.persistence.enabled"
    value = "true"
  }

  set {
    name  = "loki.persistence.size"
    value = "8Gi"
  }
}

resource "helm_release" "argo_cd" {
  name      = "argo-cd"
  namespace = kubernetes_namespace.argo.id

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "5.14.1"

  depends_on = [
    kubernetes_secret.argo_cd_github_oauth
  ]

  values = [
    file("helm/argo-cd.yaml")
  ]
}
