# variables
variable name {}
variable config {}

variable AWS_KEY_LOCATION {
  type = string
}

variable key_name {
  default = "terraform2"
}

variable setup {
  default = ["sudo amazon-linux-extras install ansible2 -y"]
}

variable services {}

variable ami {
  default = "ami-01c835443b86fe988"
}
variable connection {
  default = {
    type = "ssh",
    user = "ec2-user"
  }
}

# db setup:
resource "aws_instance" "proxy" {
  ami                    = var.ami
  instance_type          = "t2.micro"
  key_name               = var.key_name
  subnet_id              = aws_subnet.public-subnet.id
  vpc_security_group_ids = [aws_security_group.allow-ssh.id]

  tags = {
    Name = "${var.name}-db"
  }

  # transfer file:
  provisioner "file" {
    source      = var.config.source
    destination = var.config.destination

    connection {
      type = var.connection.type
      host = aws_instance.proxy.public_ip
      private_key = file(var.AWS_KEY_LOCATION)
      user = var.connection.user
    }
  }

  # execute setup:
  provisioner "remote-exec" {
    inline = concat( ["export services='${jsonencode(var.services)}'"],
                     var.setup,
                     var.config.remote_setup,
                     var.config.remote_exec_proxy,
                     var.config.remote_start)

    connection {
      type = var.connection.type
      host = aws_instance.proxy.public_ip
      private_key = file(var.AWS_KEY_LOCATION)
      user = var.connection.user
    }
  }
}

output "proxy-endpoint" {
  value = "${aws_instance.proxy.public_ip}:${var.port}"
}
