provider "aws" {
  profile = "learning"
  region = "us-west-2"

}

data "terraform_remote_state" "s3" {
  backend = "s3"

  config {
    bucket = "tfstate-bucket-deepu"
    key = "tfstate/global/s3/terraform.tfstate"
    region = "us-west-2"
    profile = "learning"
  }
}

data "template_file" "userdata" {
  template = "${file("userdata.sh")}"

  vars {
    s3_id = "${data.terraform_remote_state.s3.s3_bucket_name}"
    s3_arn = "${data.terraform_remote_state.s3.s3_bucket_arun}"
  }
}

resource "aws_instance" "web" {
  ami           = "ami-05097d999e6069ec5"
  instance_type = "t2.micro"
  key_name = "spatrayuni8"
  vpc_security_group_ids = ["sg-0067550626217dd0a","sg-0aeaecbd66cf93893", "${aws_security_group.instance-sg.id}"]
  subnet_id = "subnet-0ad83725bd1930a34"

  user_data = "${data.template_file.userdata.rendered}"

  tags = {
    Name = "WebServer1"
  }
}

resource "aws_security_group" "instance-sg" {
  name        = "allow my ip"
  description = "Allow 22 inbound traffic"
  vpc_id      = "vpc-0265410fe7bc1fe95"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["103.15.250.0/24"]
  }

  tags {
    name = "instance-sg-22"
  }
}

terraform {
  backend "s3" {
    bucket         = "tfstate-bucket-deepu"
    key            = "tfstate/stage/webserver/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
    profile        = "learning"
  }
}
