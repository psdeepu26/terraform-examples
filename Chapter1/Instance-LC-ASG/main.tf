provider "aws" {
  profile = "learning"
  region = "us-west-2"
}

data "aws_availability_zones" "available" {}

variable "subnets" {
  default = [
    "subnet-0794e8326d1df260c",
    "subnet-0849c87f273245e14",
    "subnet-0e15e9cf7ecbdf463"
  ]
  type = "list"
}

resource "aws_launch_configuration" "instance-lc" {
  name = "instance-lc"
  image_id = "ami-05097d999e6069ec5"
  instance_type = "t2.micro"
  key_name = "spatrayuni8"
  security_groups = ["${aws_security_group.instance-sg.id}"]

  user_data = <<-EOF
              #!/bin/bash
              yum install httpd -y
              echo "Hello World" > /var/www/html/index.html
              service httpd start
              EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "instance-sg" {
  name = "instance-sg"
  description = "Allow 80 and 22"
  vpc_id = "vpc-0265410fe7bc1fe95"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["103.15.250.0/24"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["103.15.250.0/24"]
  }
  tags {
    Name = "instance-lc-asg-sg"
  }
}

resource "aws_autoscaling_group" "instance-asg" {
  name = "instance-asg"
  min_size = 2
  max_size = 10
  desired_capacity = 2
  availability_zones = ["${data.aws_availability_zones.available.names}"]
  vpc_zone_identifier = ["${var.subnets}"]

  launch_configuration = "${aws_launch_configuration.instance-lc.id}"

  tags {
    key                 = "instance-lc-asg"
    value               = "instance-lc-asg"
    propagate_at_launch = true
  }

}

output "instance-lc-name" {
  value = "${aws_launch_configuration.instance-lc.name}"
}

output "instance-asg-name" {
  value = "${aws_autoscaling_group.instance-asg.name}"
}

output "instance-sg-name" {
  value = "${aws_security_group.instance-sg.name}"
}
