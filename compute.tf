data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["${var.instance_image}"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["${var.instance_image_provider_id}"]
}

resource "aws_instance" "etcd" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "${var.instance_type}"

  subnet_id              = "${aws_subnet.private.id}"
  vpc_security_group_ids = ["${aws_security_group.etcd-instance.id}"]

  key_name = "${aws_key_pair.daniel.key_name}"

  user_data = "apt-get install -y etcd"

  tags {
    Name  = "${var.env}-etcd"
    Owner = "${var.owner}"
  }
}

resource "aws_instance" "jump_box" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "${var.instance_type}"

  associate_public_ip_address = true
  subnet_id                   = "${aws_subnet.public.id}"
  vpc_security_group_ids      = ["${aws_security_group.etcd-instance.id}", "${aws_security_group.jump_box.id}"]

  key_name = "${aws_key_pair.daniel.key_name}"

  tags {
    Name  = "${var.env}-jump-box"
    Owner = "${var.owner}"
  }
}
