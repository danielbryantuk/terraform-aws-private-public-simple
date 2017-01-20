#terraform-aws-private-public-simple

Simple [Terraform](https://www.terraform.io/) AWS provider demo. After specifying
your AWS credentials (ideally via creating a ```terraform.tfvars``` file) and
running ```terraform apply``` you will end up with
* A VPC with an Internet Gateway, and a public and private subnet
* A jump box and NAT gateway in the public subnet
* A instance in the private subnet that can talk out (egress) to the internet,
but which can only be reached via sshing in through the jump box
