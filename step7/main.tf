module "module_kurata_network_step7" {
  source = "./network"

  pj          = var.pj
  vpc-cidr    = var.vpc-cidr
  subnet-cidr = var.subnet-cidr

}

module "module_kurata_instance_step7" {
  source = "./compute"

  pj                 = var.pj
  app                = "front"
  instance-type      = var.instance-type
  vpc-id             = module.module_kurata_network_step7.vpc_id
  subnet-id          = module.module_kurata_network_step7.subnets
  allow-ingress-cidr = var.allow-ingress-cidr
  allow-tcp-ports    = var.allow-tcp-ports
}

module "module_kurata_instance_back_step7" {
  source = "./compute"

  pj                 = var.pj
  app                = "back"
  instance-type      = var.instance-type
  vpc-id             = module.module_kurata_network_step7.vpc_id
  subnet-id          = module.module_kurata_network_step7.subnets
  allow-ingress-cidr = var.allow-ingress-cidr
  allow-tcp-ports    = var.allow-tcp-ports
}
