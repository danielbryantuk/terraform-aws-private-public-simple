# ------ etcd SG -------

resource "aws_security_group" "etcd-instance" {
  name   = "etcd_instance"
  vpc_id = "${aws_vpc.etcd.id}"

  tags {
    Name  = "${var.env}-etcd-instance"
    Owner = "${var.owner}"
  }
}


resource "aws_security_group_rule" "allow_jump_box_ssh_ingress" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.jump_box.id}"

  security_group_id = "${aws_security_group.etcd-instance.id}"
}

resource "aws_security_group_rule" "allow_internal_etc_traffic" {
  type      = "ingress"
  from_port = 2379
  to_port   = 2380
  protocol  = "tcp"
  self      = true

  security_group_id = "${aws_security_group.etcd-instance.id}"
}

resource "aws_security_group_rule" "allow_all_egress" {
  type        = "egress"                  #TODO - is this too permissive?
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["${var.cidr_range_all}"]

  security_group_id = "${aws_security_group.etcd-instance.id}"
}

resource "aws_security_group_rule" "allow_self_ssh" {
  type        = "egress"                  #TODO - is this too permissive?
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  self = true

  security_group_id = "${aws_security_group.etcd-instance.id}"
}

resource "aws_security_group" "jump_box" {
  name   = "jump_box"
  vpc_id = "${aws_vpc.etcd.id}"

  tags {
    Name  = "${var.env}-jump-box"
    Owner = "${var.owner}"
  }
}

# ------ jump box -------

resource "aws_security_group_rule" "allow_external_jump_box_ssh_ingress" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  cidr_blocks = ["${var.current_location_cidr}"]

  security_group_id = "${aws_security_group.jump_box.id}"
}

resource "aws_security_group_rule" "allow_jump_box_all_egress" {
  type        = "egress"                  #TODO - is this too permissive?
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["${var.cidr_range_all}"]

  security_group_id = "${aws_security_group.jump_box.id}"
}
