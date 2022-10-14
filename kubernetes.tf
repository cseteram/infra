resource "kubernetes_secret" "external_dns" {
  metadata {
    name      = "cloudflare"
    namespace = "kube-system"
  }

  data = {
    CF_API_TOKEN = var.cloudflare_api_token
  }
}
