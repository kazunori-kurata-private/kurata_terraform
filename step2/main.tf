resource "aws_vpc" "kurata_tf_test" {
  cidr_block = "10.1.0.0/16"

  tags = {
    Name = "kurata-tf-test"
  }
}

# resource "aws_subnet" "kurata_tf_test" {
#   vpc_id     = aws_vpc.kurata_tf_test.id
#   cidr_block = var.subnet_cidr

#   tags = {
#     Name = "kurata-tf-test"
#   }
# }
