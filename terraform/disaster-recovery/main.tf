provider "aws" {
  region = "us-east-1"
}

data "aws_vpc" "vpc" {
  default = true
}

resource "aws_instance" "example" {
  availability_zone = "us-east-1a"  # Specify the initial availability zone (AZ)

  # Specify other instance attributes like instance type, AMI, etc.
  instance_type     = "t2.micro"
  ami               = "ami-0715c1897453cabd1"
  # ...
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.vpc.id  # Replace with your VPC ID
}

locals {
  subnet_ids = data.aws_subnet_ids.all.ids
}

# Create a Launch Configuration
resource "aws_launch_configuration" "example" {
  name                 = "dr-launch-configuration"
  image_id             = aws_instance.example.ami
  instance_type        = aws_instance.example.instance_type
  # security_groups      = [aws_security_group.example.id]
  user_data            = aws_instance.example.user_data
  # key_name             = aws_key_pair.example.key_name
  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
    # ignore_changes = [ subnets ]
  }
}

# Create an Auto Scaling Group
resource "aws_autoscaling_group" "example" {
  name                 = "dr-autoscaling-group"
  min_size             = 1
  max_size             = 1
  desired_capacity     = 1
  launch_configuration = aws_launch_configuration.example.name
  vpc_zone_identifier  = local.subnet_ids

  # Specify other Auto Scaling Group attributes like health checks, etc.
  health_check_type    = "EC2"
  health_check_grace_period = 300
  termination_policies = ["OldestInstance"]
}
