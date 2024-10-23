resource "aws_lightsail_instance" "sekai" {
  name = "sekai"

  availability_zone = "ap-northeast-1a"
  blueprint_id      = "ubuntu_24_04"
  bundle_id         = "medium_3_0"

  user_data = <<-EOT
  #!/bin/sh

  # Configure SSH key
  curl -sSL https://github.com/cseteram.keys >> /home/ubuntu/.ssh/authorized_keys

  # Install haproxy
  sudo apt update && sudo apt install -y haproxy
  cat > /etc/haproxy/haproxy.cfg << EOF
  global
      log /dev/log local0
      log /dev/log local1 notice
      chroot /var/lib/haproxy
      stats socket /run/haproxy/admin.sock mode 660 level admin expose-fd listeners
      stats timeout 30s
      user haproxy
      group haproxy
      daemon

  defaults
      log     global
      mode    tcp
      option  httplog
      option  dontlognull
      timeout connect 5000
      timeout client  50000
      timeout server  50000

  listen k0s-http
      bind *:80
      server k0s 127.0.0.1:30080

  listen k0s-https
      bind *:443
      server k0s 127.0.0.1:30443
  EOF
  sudo systemctl reload haproxy
  EOT

  tags = {
    terraform = "true"
  }
}

resource "aws_lightsail_instance_public_ports" "sekai" {
  instance_name = aws_lightsail_instance.sekai.name

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

resource "aws_lightsail_static_ip" "sekai" {
  name = "sekai-static-ip"
}

resource "aws_lightsail_static_ip_attachment" "sekai" {
  static_ip_name = aws_lightsail_static_ip.sekai.id
  instance_name  = aws_lightsail_instance.sekai.id
}
