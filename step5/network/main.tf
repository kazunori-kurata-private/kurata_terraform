resource "aws_vpc" "kurata_tf_test_vpc" {
  cidr_block = var.vpc-cidr

  tags = {
    Name = "kurata-tf-test-step5"
  }
}

resource "aws_subnet" "kurata_tf_test_subnet" {
  for_each   = toset(var.subnet-cidrs)
  vpc_id     = aws_vpc.kurata_tf_test_vpc.id
  cidr_block = each.key

  tags = {
    Name = "kurata-tf-test-step5"
  }
}
