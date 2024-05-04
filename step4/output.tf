output "vpc_id" {
  value = aws_vpc.kurata_tf_test.id
}

# output "dynamic-sg-id" {
#   value = aws_security_group.dynamic.id
# }

# output "subnets" {
#   value = [for key, value in aws_subnet.foreach : value.id]
# }
