locals {
  name_preffix = "infocracks"

  ### VPC

  vpc_cidr  = "10.0.0.0/16"
  azs_count = min(length(data.aws_availability_zones.available.names), 3)
  azs       = slice(data.aws_availability_zones.available.names, 0, local.azs_count)

  ### EC2

  number_of_instances = 3

  user_data = <<-EOF
    #!/bin/bash
    sudo su

    yum update -y
    yum install -y httpd.x86_64
    systemctl start httpd.service
    systemctl enable httpd.service
    echo "Hello from $(hostname -f), welcome to TPE Redes - Grupo 3 website" > /var/www/html/index.html
  EOF

  tags = {
    author     = "Grupo 3 - 1C2023"
    version    = 1
    university = "ITBA"
    subject    = "Redes"
    created-by = "terraform"
    exercise   = "elb-app"
  }
}