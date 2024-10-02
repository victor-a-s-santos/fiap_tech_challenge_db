provider "aws" {
  region = "us-east-1" # Defina a região desejada
}

resource "aws_db_instance" "default" {
  allocated_storage    = 2
  engine               = "postgres"
  engine_version       = "13.4"
  instance_class       = "db.t3.micro"
  db_name                 = "db-fiap-tech-challenge"
  username             = "admin"
  password             = "admin123456"
  parameter_group_name = "default.postgres13"
  skip_final_snapshot  = true

  publicly_accessible = true

  tags = {
    Name = "terraform-rds-fiap-tech-challenge"
  }
}
