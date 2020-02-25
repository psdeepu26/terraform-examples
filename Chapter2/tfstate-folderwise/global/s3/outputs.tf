output "s3_bucket_name" {
  value = "${aws_s3_bucket.tf_bucket.id}"
}

output "s3_bucket_arun" {
  value = "${aws_s3_bucket.tf_bucket.arn}"
}
