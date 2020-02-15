provider "aws" {
  region = "us-west-2"
  shared_credentials_file = "/Users/spatrayuni/.aws/credentials"
  profile = "learning"
}

resource "aws_instance" "example" {
  ami = "ami-05097d999e6069ec5"
  instance_type = "t2.micro"
  subnet_id = "subnet-0794e8326d1df260c"

  tags {
    Name = "example1"
  }
}
