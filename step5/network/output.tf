output "vpc_id" {
  value = aws_vpc.kurata_tf_test_vpc.id
}

output "subnets" {
  value = [for key, value in aws_subnet.kurata_tf_test_subnet : value.id]
}
