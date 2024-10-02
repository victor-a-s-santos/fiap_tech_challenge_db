provider "aws" {
  region = "us-east-1" # Defina a região desejada
}

resource "aws_db_instance" "default" {
  engine               = "postgres"
  engine_version       = "14"
  db_name                 = "dbFiapTechChallenge"
  username             = "fiap"
  password             = "admin123456"
  parameter_group_name = "default.postgres14"
  port     = 5432
  skip_final_snapshot  = true
  instance_class           = "db.t3.medium"

  allocated_storage     = 10
  max_allocated_storage = 20

  publicly_accessible = true

  tags = {
    Name = "terraform-rds-fiap-tech-challenge"
  }
}
