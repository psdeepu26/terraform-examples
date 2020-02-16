provider "aws" {
  region = "us-west-2"
  profile = "learning"
}

variable "ami_id" {
  default = "ami-05097d999e6069ec5"
}

variable "subnet" {
  default = "subnet-0c0c670e69538ae55"
}

variable "vpc" {
  default = "vpc-0393e47ceb36862df"
}

variable "key" {
  default = "spatrayuni8"
}

variable "http_port" {
  default = "80"
}

variable "ssh_port" {
  default = "22"
}

resource "aws_instance" "instance1" {
  ami = "${var.ami_id}"
  subnet_id = "${var.subnet}"
  instance_type = "t2.micro"
  key_name = "${var.key}"
  associate_public_ip_address = "true"

  vpc_security_group_ids = ["${aws_security_group.instance1-sg.id}"]

  user_data = <<-EOF
              #!/bin/bash
              yum install httpd -y
              echo "Hello World" > /var/www/html/index.html
              service httpd start
              EOF

  tags {
    Name = "Per-WebServer-1"
  }
}

resource "aws_security_group" "instance1-sg" {
  name        = "instance1-sg"
  description = "Allow 80 and 22"
  vpc_id      = "${var.vpc}"

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
    Name = "instance1-sg-80-22"
  }
}

output "instance_pub_ip" {
  value = "${aws_instance.instance1.public_ip}"
}

output "sg_id" {
  value = "${aws_security_group.instance1-sg.id}"
}
