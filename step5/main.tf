module "module_kurata_network" {
  source = "./network"

  vpc-cidr     = var.vpc-cidr
  subnet-cidrs = var.subnet-cidrs

}

module "module_kurata_network_2" {
  source = "./network"

  vpc-cidr     = var.vpc-cidr
  subnet-cidrs = var.subnet-cidrs

}

module "module_kurata_instance" {
  source = "./compute"

  instance-type = var.instance-type
  subnet-id     = module.module_kurata_network.subnets[0]
}
