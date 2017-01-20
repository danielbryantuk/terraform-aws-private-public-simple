output "jump_box_ip" {
  value = "${aws_instance.jump_box.public_ip}"
}
