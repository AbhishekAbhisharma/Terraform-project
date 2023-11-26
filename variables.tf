terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "us-east-1"
  profile = "default"
}
# Variables
variable "project" {
  type    = string
  default = "myproject"
}
# Variables
variable "owner" {
  type    = string
  default = "myowner"
}
# Variables
variable "environment" {
  type    = string
  default = "dev"
}
# create vpc 
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = format("%s_%s_%s", var.project, "vpc", var.environment)
    Environment = var.environment
    owner       = var.owner
    Project     = var.project
  }
}
# subnet
resource "aws_subnet" "main_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"  # Change this to your desired availability zone

  tags = {
    Name        = format("%s_%s_%s", var.project, "sub", var.environment)
    Environment = var.environment
    owner       = var.owner
    Project     = var.project
  }
}
# Internet gateway
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = format("%s_%s_%s", var.project, "igw", var.environment)
    Environment = var.environment
    owner       = var.owner
    Project     = var.project
  }
}
# Route-table
resource "aws_route_table" "main_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }

  tags = {
    Name        = format("%s_%s_%s", var.project, "route-table", var.environment)
    Environment = var.environment
    owner       = var.owner
    Project     = var.project
  }
}
# Route-table association
resource "aws_route_table_association" "public_1_route-table_a" {
  subnet_id      = aws_subnet.main_subnet.id  
  route_table_id = aws_route_table.main_route_table.id  
}

# Ec2
resource "aws_instance" "My_ec2" {
  ami                    = "ami-0230bd60aa48260c6"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.main_subnet.id
  key_name               = "Abhishek"
  associate_public_ip_address = true

  tags = {
    Name        = format("%s_%s_%s", var.project, "Ec2", var.environment)
    Environment = var.environment
    owner       = var.owner
    Project     = var.project
  }
}
