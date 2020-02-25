provider "aws" {
  profile = "learning"
  region = "us-west-2"
}

resource "aws_db_instance" "db_instance" {
  allocated_storage    = 10
  engine               = "mysql"
  instance_class       = "db.t2.micro"
  name                 = "mydb"
  username             = "admin"
  password             = "password"
  db_subnet_group_name = "${aws_db_subnet_group.db_subnet_group.id}"
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db_subnet_group"
  subnet_ids = ["subnet-0c747e0d56ba0faa2", "subnet-0625cef388f541660", "subnet-0766e0ff4878cf65c"]
  tags = {
    Name = "db_subnet_group"
  }
}

terraform {
  backend "s3" {
    bucket         = "tfstate-bucket-deepu"
    key            = "tfstate/stage/db/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
    profile        = "learning"
  }
}
