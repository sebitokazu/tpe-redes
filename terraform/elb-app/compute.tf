module "web_server_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "web-server"
  description = "Security group for web-server with HTTP ports open within VPC"
  vpc_id      = module.vpc.vpc_id

  ingress_rules       = ["ssh-tcp", "http-80-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules        = ["all-all"]

  tags = local.tags
}

module "ec2_instances" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 2.0"

  instance_count = 3

  name                        = "${local.name_preffix}-website"
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t2.micro"
  subnet_ids                  = [for k,v in module.vpc.private_subnets : v]
  vpc_security_group_ids      = [module.web_server_sg.security_group_id]
  associate_public_ip_address = true

  user_data_base64 = base64encode(local.user_data)

  tags = local.tags

  depends_on = [module.vpc]
}