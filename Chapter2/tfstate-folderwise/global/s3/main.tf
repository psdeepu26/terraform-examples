provider "aws" {
  profile = "learning"
  region = "us-west-2"
}

resource "aws_s3_bucket" "tf_bucket" {
    bucket = "tfstate-bucket-deepu"
    acl = "private"
    region = "us-west-2"

    versioning {
      enabled = true
    }

    lifecycle {
      prevent_destroy = true
    }
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
