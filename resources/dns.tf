data "cloudflare_zone" "cseteram_dev" {
  name = "cseteram.dev"
}

resource "cloudflare_record" "sekai" {
  zone_id = data.cloudflare_zone.cseteram_dev.id
  name    = "sekai"
  content = aws_lightsail_static_ip.sekai.ip_address
  type    = "A"
  proxied = true
}
