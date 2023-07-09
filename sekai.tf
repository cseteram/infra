locals {
  owner = "cseteram"

  cluster_name = "sekaiv2"
  k0s_version  = "1.27.3+k0s.0"

  controller = {
    name = "more-more-jump"

    availability_zone = "ap-northeast-2a"
    blueprint_id      = "ubuntu_22_04"
    bundle_id         = "small_2_0"
  }

  workers = {
    name = ["minori", "haruka", "airi", "shizuku"]

    availability_zone = "ap-northeast-2a"
    blueprint_id      = "ubuntu_22_04"
    bundle_id         = "micro_2_0"
  }
}

################################################################################
# Controller
################################################################################

resource "aws_lightsail_instance" "sekaiv2_controller" {
  name = local.controller.name

  availability_zone = local.controller.availability_zone
  blueprint_id      = local.controller.blueprint_id
  bundle_id         = local.controller.bundle_id

  user_data = <<-EOT
    #!/bin/sh

    # Configure SSH key
    curl -sSL https://github.com/${local.owner}.keys >> /home/ubuntu/.ssh/authorized_keys

    # Install haproxy
    # sudo apt update
    # sudo apt install -y haproxy
    # cat > /etc/haproxy/haproxy.cfg << EOF
    # global
    #     log /dev/log local0
    #     log /dev/log local1 notice
    #     chroot /var/lib/haproxy
    #     stats socket /run/haproxy/admin.sock mode 660 level admin expose-fd listeners
    #     stats timeout 30s
    #     user haproxy
    #     group haproxy
    #     daemon

    # defaults
    #     log     global
    #     mode    tcp
    #     option  httplog
    #     option  dontlognull
    #     timeout connect 5000
    #     timeout client  50000
    #     timeout server  50000

    # listen k0s-http
    #     bind *:80
    #     server k0s 127.0.0.1:30080

    # listen k0s-https
    #     bind *:443
    #     server k0s 127.0.0.1:30443
    # EOF
    # sudo systemctl reload haproxy
  EOT

  tags = {
    Clutser   = local.cluster_name
    Name      = local.controller.name
    Role      = "controller"
    Terraform = "true"
  }
}

resource "aws_lightsail_instance_public_ports" "sekaiv2_controller" {
  instance_name = aws_lightsail_instance.sekaiv2_controller.name

  port_info {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
  }
  port_info {
    protocol  = "tcp"
    from_port = 80
    to_port   = 80
  }
  port_info {
    protocol  = "tcp"
    from_port = 443
    to_port   = 443
  }
  port_info {
    protocol  = "tcp"
    from_port = 6443
    to_port   = 6443
  }
}

################################################################################
# Workers
################################################################################

resource "aws_lightsail_instance" "sekaiv2_workers" {
  count = length(local.workers.name)

  name = local.workers.name[count.index]

  availability_zone = local.workers.availability_zone
  blueprint_id      = local.workers.blueprint_id
  bundle_id         = local.workers.bundle_id

  user_data = <<-EOT
    #!/bin/sh

    # Configure SSH key
    curl -sSL https://github.com/${local.owner}.keys >> /home/ubuntu/.ssh/authorized_keys
  EOT

  tags = {
    Clutser   = local.cluster_name
    Name      = local.workers.name[count.index]
    Role      = "worker"
    Terraform = "true"
  }
}

resource "aws_lightsail_instance_public_ports" "sekaiv2_workers" {
  count = length(local.workers.name)

  instance_name = aws_lightsail_instance.sekaiv2_workers[count.index].name

  port_info {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
  }
  port_info {
    protocol  = "tcp"
    from_port = 80
    to_port   = 80
  }
  port_info {
    protocol  = "tcp"
    from_port = 443
    to_port   = 443
  }
}

################################################################################
# K0sctl configurations
################################################################################

locals {
  sekaiv2_k0sctl_tmpl = {
    apiVersion = "k0sctl.k0sproject.io/v1beta1"
    kind       = "Cluster"
    metadata = {
      name = local.cluster_name
    }
    spec = {
      hosts = [
        for host in concat([aws_lightsail_instance.sekaiv2_controller], aws_lightsail_instance.sekaiv2_workers) : {
          role     = host.tags["Role"]
          hostname = host.tags["Name"]

          ssh = {
            address = host.public_ip_address
            user    = host.username
            port    = 22
            keyPath = "~/.ssh/id_ed25519"
          }
        }
      ]
      k0s = {
        version = local.k0s_version
      }
    }
  }
}
