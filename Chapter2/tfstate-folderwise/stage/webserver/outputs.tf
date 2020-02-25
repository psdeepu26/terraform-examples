output "instance_id" {
  value = "${aws_instance.web.id}"
}

output "private_ip" {
  value = "${aws_instance.web.private_ip}"
}

output "sg_id" {
  value = "${aws_security_group.instance-sg.id}"
}

output "instance_private_ip" {
  value = "${aws_security_group.instance-sg.name}"
}
