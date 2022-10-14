resource "cloudflare_record" "sekai" {
  zone_id = var.cloudflare_zone_id

  name  = "sekai"
  type  = "A"
  value = aws_lightsail_instance.sekai.public_ip_address

  proxied = true
}
