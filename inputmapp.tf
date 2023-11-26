terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}
# mapping
variable "zones" {
  type = map(any)
  default = {
    "us-east-1" = "ami-0fc5d935ebf8bc3bc"
    "us-west-1" = "ami-56412"
  }
}
# user input 
variable "selected_zone" {
  description = "Enter the desired AWS region (e.g., us-east-1,)"
  type        = string
}

provider "aws" {
  region = var.selected_zone
  profile = "default"
}

resource "aws_instance" "example_instance" {
  ami           = var.zones[var.selected_zone]
  instance_type = "t2.micro"

  // Other instance configurations go here
}
