terraform {
 required_providers {
   aws = {
     source = "hashicorp/aws"
     version = "~> 4.16"
   }
 }

 required_version = ">= 1.2.0"
}

provider "aws" {
 region  = "us-east-1"
 profile = "default"
}

resource "aws_instance" "EC2" {
 ami           = "ami-0fc5d935ebf8bc3bc"
 instance_type = "t2.micro"
 key_name      = "Abhishek"
}
output "instances" {
 value       = aws_instance.example_server.public_ip
 description = "EC2 details"
}
