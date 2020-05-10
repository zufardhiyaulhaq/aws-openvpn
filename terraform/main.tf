resource "aws_key_pair" "vpn_keypair" {
  key_name   = var.aws_keyname
  public_key = file(var.aws_keyfile)
}

resource "aws_default_vpc" "default" {
}

resource "aws_security_group" "vpn_sg" {
  name        = "vpn_sg"
  description = "Allow OpenVPN inbound traffic"
  vpc_id      = "${aws_default_vpc.default.id}"

  ingress {
    description = "openVPN from public"
    from_port   = var.ovpn_port
    to_port     = var.ovpn_port
    protocol    = var.ovpn_protocol
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from public"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "instance_openvpn_netflix" {
  ami           = var.aws_ami
  instance_type = var.aws_instancetype
  key_name      = aws_key_pair.vpn_keypair.key_name
  security_groups = [
    "${aws_security_group.vpn_sg.name}",
  ]
}

output "vm_public_ip" {
  value = aws_instance.instance_openvpn_netflix.public_ip
}

output "vm_public_dns" {
  value = aws_instance.instance_openvpn_netflix.public_dns
}

resource "null_resource" "delay" {
  provisioner "local-exec" {
    command = "sleep 30"
  }

  depends_on = [
    aws_instance.instance_openvpn_netflix,
  ]
}

resource "null_resource" "append_ansible_host" {
  provisioner "local-exec" {
    command = "echo '${aws_instance.instance_openvpn_netflix.public_ip} ansible_user=ubuntu ansible_become=yes ansible_python_interpreter=python3' >> ../ansible/hosts/hosts.ini"
  }

  depends_on = [
    null_resource.delay,
  ]
}
