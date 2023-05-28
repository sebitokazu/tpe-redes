module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2.0"

  cidr = local.vpc_cidr

  name = "${local.name_preffix}-elb-vpc"

  azs = local.azs
  # private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]
  # usamos public para no tener que mandar un nat gateway para que se conecte a internet, si tenemos tiempo lo mejoramos
  public_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]

  create_igw = true

  enable_dns_hostnames = true
  enable_dns_support   = true
}
