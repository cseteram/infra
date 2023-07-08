output "sekai_public_ip_address" {
  value = aws_lightsail_instance.sekai.public_ip_address
}

output "sekai_username" {
  value = aws_lightsail_instance.sekai.username
}

output "sekai_k0sctl_config" {
  value = yamlencode(local.k0sctl_tmpl)
}

output "sekaiv2_controller_public_ip_address" {
  value = aws_lightsail_instance.sekaiv2_controller.public_ip_address
}

output "sekaiv2_workers_public_ip_address" {
  value = aws_lightsail_instance.sekaiv2_workers.*.public_ip_address
}

output "sekaiv2_k0sctl_config" {
  value = yamlencode(local.sekaiv2_k0sctl_tmpl)
}
