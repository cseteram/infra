resource "kubernetes_secret" "external_dns" {
  metadata {
    name      = "cloudflare"
    namespace = "kube-system"
  }

  data = {
    CF_API_TOKEN = var.cloudflare_api_token
  }
}

# resource "kubernetes_namespace" "dashboard" {
#   metadata {
#     name = "dashboard"
#   }
# }
# 
# resource "kubernetes_secret" "grafana_github_oauth" {
#   metadata {
#     name      = "github-oauth"
#     namespace = kubernetes_namespace.dashboard.id
#   }
# 
#   data = {
#     secret = var.grafana_github_oauth_client_secret
#   }
# }

resource "kubernetes_namespace" "argo" {
  metadata {
    name = "argo"
  }
}

resource "kubernetes_secret" "argo_cd_github_oauth" {
  metadata {
    name      = "github-oauth"
    namespace = kubernetes_namespace.argo.id

    labels = {
      "app.kubernetes.io/part-of" = "argocd"
    }
  }

  data = {
    "dex.github.clientSecret" = var.argo_cd_github_oauth_client_secret
  }
}
