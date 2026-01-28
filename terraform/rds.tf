# 1. Generate a Random Password
resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "_%@" 
}

# 2. Create the "Safe" (Secrets Manager Secret)
resource "aws_secretsmanager_secret" "db_secret" {
  name_prefix = "my-production-db-password-" # using name_prefix avoids "already exists" errors
  description = "Master password for the RDS database"
}

# 3. Put the Password IN the Safe
resource "aws_secretsmanager_secret_version" "db_secret_val" {
  secret_id     = aws_secretsmanager_secret.db_secret.id
  secret_string = random_password.db_password.result
}

# 4. Create a Subnet Group (Where the DB lives)
resource "aws_db_subnet_group" "default" {
  name       = "main-subnet-group"
  subnet_ids = module.vpc.private_subnets

  tags = {
    Name = "My DB subnet group"
  }
}

# 5. Create the Firewall Rule (Security Group) -> THIS IS THE MISSING PIECE
resource "aws_security_group" "rds_sg" {
  name        = "allow_eks_to_rds"
  description = "Allow inbound traffic from EKS"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "MySQL from EKS"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [module.eks.node_security_group_id]
  }
}

# 6. Create the Database Instance
resource "aws_db_instance" "default" {
  allocated_storage      = 10
  db_name                = "mydb"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  username               = "admin"
  password               = random_password.db_password.result
  parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.default.name
}

# 7. Output the Address
output "rds_endpoint" {
  value = aws_db_instance.default.address
}