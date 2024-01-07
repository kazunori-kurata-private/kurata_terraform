output "vpc_id" {
  value = aws_vpc.kurata_tf_test.id
}

output "vpc_arn" {
  value = aws_vpc.kurata_tf_test.arn
}

# output "subnet" {
#   value = aws_subnet.kurata_tf_test
# }
