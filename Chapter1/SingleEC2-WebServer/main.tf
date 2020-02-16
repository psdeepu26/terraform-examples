provider "aws" {
  profile = "learning"
  region = "us-west-2"
}

resource "aws_instance" "SingleEC2-WebServer" {

  ami = "ami-05097d999e6069ec5"
  instance_type = "t2.micro"
  key_name = "spatrayuni8"
  subnet_id = "subnet-0794e8326d1df260c"
  associate_public_ip_address = "true"
  vpc_security_group_ids = ["${aws_security_group.SingleEC2-WebServer-Ingress-SG.id}"]

  user_data = <<-EOF
              #!/bin/bash
              yum install httpd -y
              echo "Hello World" > /var/www/html/index.html
              service httpd start
              EOF

  tags {
    Name = "SingleEC2-WebServer"
  }
}

resource "aws_security_group" "SingleEC2-WebServer-Ingress-SG" {
  name        = "SingleEC2-WebServer-Ingress-SG"
  description = "Allow 80 to web server"
  vpc_id      = "vpc-0265410fe7bc1fe95"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["103.15.250.0/24"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["103.15.250.0/24"]
  }

  tags = {
    Name = "SingleEC2-WebServer-Ingress-SG"
  }
}
