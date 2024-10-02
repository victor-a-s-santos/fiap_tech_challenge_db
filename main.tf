provider "aws" {
  region = "us-east-1" # Defina a região desejada
}

resource "aws_db_instance" "default" {
  allocated_storage    = 2
  max_allocated_storage = 4
  engine               = "postgres"
  engine_version       = "14"
  instance_class       = "db.t3.micro"
  db_name                 = "dbFiapTechChallenge"
  username             = "admin"
  password             = "admin123456"
  parameter_group_name = "default.postgres14"
  port     = 5432
  skip_final_snapshot  = true

  publicly_accessible = true

  tags = {
    Name = "terraform-rds-fiap-tech-challenge"
  }
}
