locals {
  cidr_block      = "0.0.0.0/0"
  subnets_private = length(var.ntier_vpc.subnets_private)
  subnets_public  = length(var.ntier_vpc.subnets_public)
}