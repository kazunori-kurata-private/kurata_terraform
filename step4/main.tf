resource "aws_vpc" "kurata_tf_test" {
  cidr_block = var.vpc-cidr

  # enable_dns_support   = var.dev == true ? true : false
  # enable_dns_hostnames = var.dev == true ? true : false

  tags = {
    Name = "kurata-tf-test-step4"
  }
}

resource "aws_subnet" "foreach" {
  for_each = var.dev == true ? toset(var.subnet-cidrs) : toset([])

  vpc_id     = aws_vpc.kurata_tf_test.id
  cidr_block = each.key
}
