module "loadbalancer_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 3.0"

  name        = "loadbalancer-sg"
  description = "Security group with HTTP port open for everybody (IPv4 CIDR), egress ports are all world open"
  vpc_id      = module.vpc.vpc_id
  # Ingress Rules & CIDR Block  
  ingress_rules       = ["http-80-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  # Egress Rule - all-all open
  egress_rules = ["all-all"]

  tags = local.tags
}

module "elb" {
  source  = "terraform-aws-modules/elb/aws"
  version = "~> 2.0"
  name    = "${local.name_preffix}-elb"
  subnets = [for k, v in module.vpc.public_subnets : v]
  listener = [
    {
      instance_port     = 80
      instance_protocol = "HTTP"
      lb_port           = 80
      lb_protocol       = "HTTP"
    },
  ]

  health_check = {
    target              = "HTTP:80/"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
  }

  security_groups = [module.loadbalancer_sg.this_security_group_id]

  # ELB attachments
  number_of_instances = 3
  instances = [for k, v in  module.ec2_instances.id : v]

  tags = local.tags

  depends_on = [module.ec2_instances]
}