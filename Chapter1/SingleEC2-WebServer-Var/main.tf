provider "aws" {
  region = "us-west-2"
  profile = "learning"
}

variable "http_port" {
  default = 80
}

variable "ssh_port" {
  default = 80
}

resource "aws_instance" "SingleEc2-WebServer-Var" {
  ami = "ami-05097d999e6069ec5"
  instance_type = "t2.micro"
  subnet_id = "subnet-0794e8326d1df260c"
  key_name = "spatrayuni8"
  security_group_owner_id = ["${aws_security_group.SingleEc2-WebServer-Var.id}"]

  user_data = <<-EOF
              #!/bin/bash
              yum install httpd -y
              echo "Hello World" > /var/www/html/index.html
              service httpd start
              EOF

  tags {
    Name = "SingleEc2-WebServer-Var"
  }
}

resource "aws_security_group" "SingleEc2-WebServer-Var" {
  name        = "SingleEc2-WebServer-Var"
  description = "SingleEc2-WebServer-Var"
  vpc_id      = "vpc-0265410fe7bc1fe95"

  ingress {
    from_port   = "${var.http_port}"
    to_port     = "${var.http_port}"
    protocol    = "tcp"
    cidr_blocks = ["103.15.250.0/24"]
  }

  ingress {
    from_port   = "${var.ssh_port}"
    to_port     = "${var.ssh_port}"
    protocol    = "tcp"
    cidr_blocks = ["103.15.250.0/24"]
  }

  tags = {
    Name = "SingleEc2-WebServer-Var"
  }
}
