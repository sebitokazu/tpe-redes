module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2.0"

  create_vpc = try(local.create_vpc, true)

  name = "${local.name_preffix}-vpc"

  cidr = local.vpc_cidr

  azs             = local.azs
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 4)]

  public_dedicated_network_acl = true
  public_inbound_acl_rules     = local.network_acls["public_inbound"]
  public_outbound_acl_rules    = local.network_acls["public_outbound"]

  create_igw = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_ipv6 = try(local.enable_ipv6, false)

  enable_nat_gateway = true
  single_nat_gateway = false

  tags = local.tags
}