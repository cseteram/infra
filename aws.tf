resource "aws_lightsail_instance" "sekai" {
  name = "sekai"

  availability_zone = "ap-northeast-2a"
  blueprint_id      = "ubuntu_20_04"
  bundle_id         = "medium_2_0"

  user_data = file("scripts/init-sekai.sh")

  tags = {
    Name      = "sekai"
    Terraform = "true"
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
