locals {
  name_preffix = "infocracks"

  create_vpc            = true

  vpc_cidr              = "10.0.0.0/16"
  azs_count             = min(length(data.aws_availability_zones.available.names), 3)
  azs                   = slice(data.aws_availability_zones.available.names, 0, local.azs_count)

  enable_ipv6           = false

  network_acls = {
    # default_inbound = [
    #   {
    #     rule_number = 900
    #     rule_action = "allow"
    #     from_port   = 1024
    #     to_port     = 65535
    #     protocol    = "tcp"
    #     cidr_block  = "0.0.0.0/0"
    #   },
    # ]
    # default_outbound = [
    #   {
    #     rule_number = 900
    #     rule_action = "allow"
    #     from_port   = 32768
    #     to_port     = 65535
    #     protocol    = "tcp"
    #     cidr_block  = "0.0.0.0/0"
    #   },
    # ]
    public_inbound = [
      {
        rule_number = 100
        rule_action = "allow"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      {
        rule_number = 110
        rule_action = "allow"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      {
        rule_number = 120
        rule_action = "allow"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
    ]
    public_outbound = [
      {
        rule_number = 100
        rule_action = "allow"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      {
        rule_number = 110
        rule_action = "allow"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      {
        rule_number = 130
        rule_action = "allow"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_block  = "10.0.100.0/22"
      },
      {
        rule_number = 140
        rule_action = "allow"
        icmp_code   = -1
        icmp_type   = 8
        protocol    = "icmp"
        cidr_block  = "10.0.0.0/22"
      },
    ]
  }

}