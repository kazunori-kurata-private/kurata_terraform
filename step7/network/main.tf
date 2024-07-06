resource "aws_vpc" "kurata_tf_test_vpc" {
  cidr_block = var.vpc-cidr

  tags = {
    Name = "${var.pj}-vpc"
  }
}

resource "aws_subnet" "kurata_tf_test_subnet" {
  vpc_id     = aws_vpc.kurata_tf_test_vpc.id
  cidr_block = var.subnet-cidr

  tags = {
    Name = "${var.pj}-subnet"
  }
}
