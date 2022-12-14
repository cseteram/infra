locals {
  k0sctl_tmpl = {
    apiVersion = "k0sctl.k0sproject.io/v1beta1"
    kind       = "Cluster"
    metadata = {
      name = aws_lightsail_instance.sekai.name
    }
    spec = {
      hosts = [
        {
          ssh = {
            address = aws_lightsail_instance.sekai.public_ip_address
            user    = aws_lightsail_instance.sekai.username
            port    = 22
            keyPath = "~/.ssh/id_ed25519"
          }
          role     = "controller+worker"
          noTaints = true
        }
      ]
      k0s = {
        version       = "1.25.2+k0s.0"
        dynamicConfig = false
      }
    }
  }
}
