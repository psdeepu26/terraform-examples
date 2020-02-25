provider "aws" {
  profile = "learning"
  region = "us-west-2"

}

resource "aws_security_group" "instance-sg" {
  name        = "allow my ip"
  description = "Allow 443 inbound traffic"
  vpc_id      = "vpc-0265410fe7bc1fe95"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["103.15.250.0/24"]
  }

  tags {
    name = "instance-sg-443"
  }
}

terraform {
  backend "s3" {
    bucket         = "tfstate-bucket-deepu"
    key            = "tfstate/stage/sg/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
    profile        = "learning"
  }
}
