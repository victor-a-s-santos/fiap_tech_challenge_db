terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1" 
}

data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 4.0"

  name                 = "fiap"
  cidr                 = "10.0.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_dns_hostnames = true
  enable_dns_support   = true
  # Remover enable_classiclink e enable_classiclink_dns_support
}

resource "aws_db_subnet_group" "fiap" {
  name       = "fiap"
  subnet_ids = module.vpc.public_subnets

  tags = {
    Name = "Fiap"
  }
}

resource "aws_security_group" "rds" {
  name   = "fiap_rds"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "fiap_rds"
  }
}

resource "aws_db_parameter_group" "fiap" {
  name   = "fiap"
  family = "postgres14"

  parameter {
    name  = "log_connections"
    value = "1"
  }
}

resource "aws_db_instance" "fiap" {
  identifier             = "fiap"
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "14"
  username               = "fiap"
  password               = "admin123456"
  db_subnet_group_name   = aws_db_subnet_group.fiap.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  parameter_group_name   = aws_db_parameter_group.fiap.name
  publicly_accessible    = true
  skip_final_snapshot    = true
}
