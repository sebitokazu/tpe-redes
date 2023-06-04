# Define provider and region
provider "aws" {
  region = "us-west-2"  # Active region
}

# Create VPC
resource "aws_vpc" "active" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "active_subnet" {
  vpc_id            = aws_vpc.active.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"  # Active AZ
}

# Create Active EC2 Instance
resource "aws_instance" "active_instance" {
  ami           = "ami-12345678"  # Replace with your desired AMI
  instance_type = "t2.micro"      # Replace with your desired instance type
  subnet_id     = aws_subnet.active_subnet.id

  # Add any other necessary configuration (e.g., security groups, user data, etc.)
}

# Create Active Load Balancer
resource "aws_lb" "active_lb" {
  name               = "active-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.active_subnet.id]

  # Add any other necessary configuration (e.g., listeners, target groups, etc.)
}

# Create Passive region resources
provider "aws" {
  alias  = "passive"
  region = "us-east-1"  # Passive region
}

resource "aws_vpc" "passive" {
  cidr_block = "10.0.0.0/16"
  provider   = aws.passive
}

resource "aws_subnet" "passive_subnet" {
  vpc_id            = aws_vpc.passive.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"  # Passive AZ
  provider          = aws.passive
}

# Create Passive EC2 Instance
resource "aws_instance" "passive_instance" {
  ami           = "ami-12345678"  # Replace with your desired AMI
  instance_type = "t2.micro"      # Replace with your desired instance type
  subnet_id     = aws_subnet.passive_subnet.id
  provider      = aws.passive

  # Add any other necessary configuration (e.g., security groups, user data, etc.)
}

# Create Passive Load Balancer
resource "aws_lb" "passive_lb" {
  name               = "passive-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.passive_subnet.id]
  provider           = aws.passive

  # Add any other necessary configuration (e.g., listeners, target groups, etc.)
}

# Route53 Configuration
resource "aws_route53_health_check" "active_health_check" {
  fqdn      = aws_lb.active_lb.dns_name
  port      = 80  # Replace with the appropriate port for health checks
  type      = "HTTP"
  resource_path = "/health"
  request_interval = 30
  failure_threshold = 3
}

resource "aws_route53_health_check" "passive_health_check" {
  fqdn      = aws_lb.passive_lb.dns_name
  port      = 80  # Replace with the appropriate port for health checks
  type      = "HTTP"
  resource_path = "/health"
  request_interval = 30
  failure_threshold = 3
}

resource "aws_route53_record" "active_to_passive_failover" {
  zone_id = "your_zone_id"
  name    = "your.domain.com"
  type    = "A"
  alias {
    name                   = aws_lb.active_lb.dns_name
    zone_id                = aws_lb.active_lb.zone_id
    evaluate_target_health = true
  }
  health_check_id = aws_route53_health_check.active_health_check.id
  set_identifier  = "primary"
  failover_routing_policy {
    type             = "PRIMARY"
    status           = "ENABLED"
    ttl              = 60
    record_set_id    = aws_route53_record.active_to_passive_failover.id
  }
}

resource "aws_route53_record" "passive_to_active_failover" {
  zone_id = "your_zone_id"
  name    = "your.domain.com"
  type    = "A"
  alias {
    name                   = aws_lb.passive_lb.dns_name
    zone_id                = aws_lb.passive_lb.zone_id
    evaluate_target_health = true
  }
  health_check_id = aws_route53_health_check.passive_health_check.id
  set_identifier  = "secondary"
  failover_routing_policy {
    type             = "SECONDARY"
    status           = "ENABLED"
    ttl              = 60
    record_set_id    = aws_route53_record.passive_to_active_failover.id
  }
}

