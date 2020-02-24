provider "aws" {
  region = "us-west-2"
  profile = "learning"
}

resource "aws_s3_bucket" "s3-remotestate-configure" {
  bucket = "tf-learn-deepu"
  acl = "private"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }
}

output "s3_bucket_arn" {
  value = "${aws_s3_bucket.s3-remotestate-configure.arn}"
}
