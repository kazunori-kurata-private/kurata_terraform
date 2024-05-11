output "module_vpc_id" {
  value = module.module_kurata_network.vpc_id
}

output "module_subnets" {
  value = module.module_kurata_network.subnets
}

output "module_vpc_id-2" {
  value = module.module_kurata_network_2.vpc_id
}

output "module_subnets-2" {
  value = module.module_kurata_network_2.subnets
}

output "module_instance" {
  value = module.module_kurata_instance.instance
}

# output "dynamic-sg-id" {
#   value = aws_security_group.dynamic.id
# }
