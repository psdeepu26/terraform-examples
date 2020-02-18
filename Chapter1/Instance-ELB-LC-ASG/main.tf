provider "aws" {
  profile = "learning"
  region = "us-west-2"
}

data "aws_availability_zones" "all" {}

variable "pub_subnets" {
  default = [
    "subnet-0ad83725bd1930a34",
    "subnet-0a631f5aaa42855b3",
    "subnet-0680dd0b84fe5426a"
  ]
  type = "list"
}

variable "pvt_subnets" {
  default = [
    "subnet-0794e8326d1df260c",
    "subnet-0849c87f273245e14",
    "subnet-0e15e9cf7ecbdf463"
    ]
  type = "list"
}

variable "bastion-sg" {
  default = [
    "sg-0067550626217dd0a",
    "sg-0aeaecbd66cf93893"
  ]
  type = "list"
}

resource "aws_security_group" "elb-sg" {
  name = "elb-sg"
  description = "Allow 80"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["103.15.250.0/24"]
  }

  vpc_id = "vpc-0265410fe7bc1fe95"

  tags {
    Name = "elb-sg"
  }
}

resource "aws_elb" "elb" {
  name = "elb"
  security_groups = ["${aws_security_group.elb-sg.id}"]
  subnets = ["${var.pub_subnets}"]

  listener {
    instance_port = 80
    instance_protocol = "tcp"
    lb_port = 80
    lb_protocol = "tcp"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:80/"
    interval = 30
  }

  cross_zone_load_balancing = "true"

  tags {
    Name = "elb"
  }

}

resource "aws_launch_configuration" "elb-instance-lc" {
  name = "elb-instance-lc"
  image_id = "ami-05097d999e6069ec5"
  instance_type = "t2.micro"
  key_name = "spatrayuni8"
  security_groups = ["${aws_security_group.asg-sg.id}"]

  user_data = <<-EOF
              #!/bin/bash
              yum install httpd -y
              echo "Hello World" > /var/www/html/index.html
              service httpd start
              EOF
}

resource "aws_autoscaling_group" "elb-instance-asg" {
  name = "elb-instance-asg"
  min_size = 2
  max_size = 4
  desired_capacity = 2

  launch_configuration = "${aws_launch_configuration.elb-instance-lc.name}"
  health_check_type = "ELB"
  load_balancers = ["${aws_elb.elb.id}"]

  vpc_zone_identifier = ["${var.pvt_subnets}"]

  tags {
    key = "Name"
    value = "instance-asg"
    propagate_at_launch = "true"
  }

}

resource "aws_security_group" "asg-sg" {
  name        = "asg-sg"
  description = "Allow ELB traffic"
  vpc_id      = "vpc-0265410fe7bc1fe95"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = ["${aws_security_group.elb-sg.id}"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["103.15.250.0/24"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = "${var.bastion-sg}"
  }

  tags = {
    Name = "asg-sg"
  }

}
