output "sekai_username" {
  value = aws_lightsail_instance.sekai.username
}

output "sekai_static_ip_address" {
  value = aws_lightsail_static_ip.sekai.ip_address
}

output "sekai_k0sctl_config" {
  value = yamlencode(local.k0sctl_tmpl)
}
