# To setup k0s, run the following command after provisioning:
#   terraform output -raw sekai_k0sctl_config | k0sctl apply --config -

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
            address = aws_lightsail_static_ip.sekai.ip_address
            user    = aws_lightsail_instance.sekai.username
            port    = 22
            keyPath = "~/.ssh/id_ed25519"
          }
          role     = "controller+worker"
          noTaints = true
        }
      ]
      k0s = {
        version       = "v1.31.1+k0s.1"
        dynamicConfig = false
      }
    }
  }
}
