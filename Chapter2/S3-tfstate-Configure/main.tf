provider "aws" {
  profile = "learning"
  region = "us-west-2"

}

terraform {
  backend "s3" {
    bucket = "tf-learn-deepu"
    key = "global/s3/terraform.tfstate"
    region = "us-west-2"
    profile = "learning"
  }
}
