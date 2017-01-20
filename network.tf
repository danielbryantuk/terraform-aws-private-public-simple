# --- VPC

resource "aws_vpc" "demo" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags {
    Name  = "${var.env}-vpc"
    Owner = "${var.owner}"
  }
}

resource "aws_internet_gateway" "demo" {
  vpc_id = "${aws_vpc.demo.id}"

  tags {
    Name  = "${var.env}-internet-gateway"
    Owner = "${var.owner}"
  }
}

# --- public subnets

resource "aws_subnet" "public" {
  vpc_id = "${aws_vpc.demo.id}"

  cidr_block        = "${var.public_subnet_cidrs}"
  availability_zone = "${var.availability_zones}"

  tags {
    Name  = "${var.env}-public-subnet"
    Owner = "${var.owner}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.demo.id}"

  route {
    cidr_block = "${var.cidr_range_all}"
    gateway_id = "${aws_internet_gateway.demo.id}"
  }

  tags {
    Name  = "${var.env}-public-subnet-route"
    Owner = "${var.owner}"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = "${aws_subnet.public.id}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_eip" "public_nat" {
  vpc = true
}

resource "aws_nat_gateway" "public" {
  depends_on    = ["aws_internet_gateway.demo"]
  allocation_id = "${aws_eip.public_nat.id}"
  subnet_id     = "${aws_subnet.public.id}"
}

# --- private subnets

resource "aws_subnet" "private" {
  vpc_id = "${aws_vpc.demo.id}"

  cidr_block        = "${var.private_subnet_cidrs}"
  availability_zone = "${var.availability_zones}"

  tags {
    Name  = "${var.env}-private-subnet"
    Owner = "${var.owner}"
  }
}

resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.demo.id}"

  route {
    cidr_block     = "${var.cidr_range_all}"
    nat_gateway_id = "${aws_nat_gateway.public.id}"
  }

  tags {
    Name  = "${var.env}-private-subnet-route"
    Owner = "${var.owner}"
  }
}

resource "aws_route_table_association" "private" {
  subnet_id      = "${aws_subnet.private.id}"
  route_table_id = "${aws_route_table.private.id}"
}
