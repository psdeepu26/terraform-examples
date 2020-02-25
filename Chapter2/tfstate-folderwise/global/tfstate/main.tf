provider "aws" {
  profile = "learning"
  region = "us-west-2"
}

terraform {
  backend "s3" {
    bucket = "tfstate-bucket-deepu"
    key = "tfstate/global/s3/terraform.tfstate"
    region = "us-west-2"
    profile = "learning"
    encrypt = "true"
  }
}
