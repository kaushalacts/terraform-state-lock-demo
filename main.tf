provider "aws" {
  region = var.aws_region
}

# -------------------------
# Networking resources
# -------------------------

# Create a custom VPC
resource "aws_vpc" "demo" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "TerraformDemoVPC"
  }
}

# Create a public subnet
resource "aws_subnet" "demo" {
  vpc_id                  = aws_vpc.demo.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "TerraformDemoSubnet"
  }
}

# Internet Gateway for internet access
resource "aws_internet_gateway" "demo" {
  vpc_id = aws_vpc.demo.id

  tags = {
    Name = "TerraformDemoIGW"
  }
}

# Route Table
resource "aws_route_table" "demo" {
  vpc_id = aws_vpc.demo.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo.id
  }

  tags = {
    Name = "TerraformDemoRouteTable"
  }
}

# Associate Route Table with Subnet
resource "aws_route_table_association" "demo" {
  subnet_id      = aws_subnet.demo.id
  route_table_id = aws_route_table.demo.id
}

# Security Group
resource "aws_security_group" "demo" {
  vpc_id = aws_vpc.demo.id
  name   = "terraform-demo-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # SSH (not safe in prod, but okay for demo)
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # HTTP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "TerraformDemoSG"
  }
}

# -------------------------
# Compute resources
# -------------------------

# Get latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# EC2 Instance
resource "aws_instance" "demo" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t2.micro"

  subnet_id              = aws_subnet.demo.id
  vpc_security_group_ids = [aws_security_group.demo.id]

  tags = {
    Name        = "TerraformLockDemo"
    Environment = var.environment
    Timestamp   = timestamp()
  }
}

# -------------------------
# Random resource to simulate changes
# -------------------------
resource "random_string" "demo" {
  length  = 8
  special = false

  keepers = {
    timestamp = var.force_update ? timestamp() : "static"
  }
}

# -------------------------
# Data Sources
# -------------------------
data "aws_availability_zones" "available" {}
