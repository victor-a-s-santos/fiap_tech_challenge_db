provider "aws" {
  region = "us-east-1" 
}

resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "rds-fiap-vpc"
  }
}

resource "aws_subnet" "subnet_a" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = "10.0.1.0/24" 
  availability_zone = "us-east-1a"

  tags = {
    Name = "subnet-a"
  }
}

resource "aws_subnet" "subnet_b" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = "10.0.2.0/24" 
  availability_zone = "us-east-1b"

  tags = {
    Name = "subnet-b"
  }
}

resource "aws_db_subnet_group" "default" {
  name       = "rds-subnet-group"
  description = "Subnet group para RDS"
  subnet_ids = [
    aws_subnet.subnet_a.id,
    aws_subnet.subnet_b.id,
  ]

  tags = {
    Name = "rds-subnet-group"
  }
}

resource "aws_db_instance" "default" {
  db_subnet_group_name = aws_db_subnet_group.default.name
  engine               = "postgres"
  engine_version       = "14"
  db_name                 = "dbFiapTechChallenge"
  username             = "fiap"
  password             = "admin123456"
  parameter_group_name = "default.postgres14"
  port     = 5432
  skip_final_snapshot  = true
  instance_class           = "db.t4g.micro"

  allocated_storage     = 10
  max_allocated_storage = 20

  publicly_accessible = true

  tags = {
    Name = "terraform-rds-fiap-tech-challenge"
  }
}
