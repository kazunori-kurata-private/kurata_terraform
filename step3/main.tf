resource "aws_vpc" "kurata_tf_test" {
  cidr_block = var.vpc-cidr

  tags = {
    Name = "kurata-tf-test"
  }
}

# resource "aws_subnet" "count" {
#   count = length(var.subnet-cidrs)

#   vpc_id     = aws_vpc.kurata_tf_test.id
#   cidr_block = var.subnet-cidrs[count.index]
# }

resource "aws_subnet" "foreach" {
  for_each = toset(var.subnet-cidrs)

  vpc_id     = aws_vpc.kurata_tf_test.id
  cidr_block = each.key
}

resource "aws_security_group" "dynamic" {
  name        = "kurata-sg-dynamic-test"
  description = "kurata sg dynamic Test"
  vpc_id      = aws_vpc.kurata_tf_test.id

  # dynamic "ingress" {
  #   for_each = toset(var.sg-allow-cidrs)
  #   content {
  #     description = "TLS from VPC"
  #     from_port   = 443
  #     to_port     = 443
  #     protocol    = "tcp"
  #     cidr_blocks = [ingress.key]
  #   }
  # }

  dynamic "ingress" {
    for_each = var.sg-ingress-rulus
    content {
      description = "TLS from VPC"
      from_port   = 443
      to_port     = 443
      protocol    = ingress.value.protocol
      cidr_blocks = [ingress.key]
    }
  }
}
