resource "aws_db_instance" "_mysql" {
  engine                 = "mysql"
  identifier             = "depi-mysql"
  instance_class         = "db.t3.micro"
  parameter_group_name   = "default.mysql8.0"
  allocated_storage      = var.DB-storage
  engine_version         = var.DB-engine-version
  username               = var.DB-admin
  password               = var.DB-password
  vpc_security_group_ids = [aws_security_group._SG_RDS.id]
  db_subnet_group_name   = aws_db_subnet_group._RDS_Subnet.name
  multi_az               = false
  skip_final_snapshot    = true // required to destroy
  publicly_accessible    = false

  backup_retention_period = 7                     # Number of days to retain automated backups
  backup_window           = "03:00-04:00"         # Preferred UTC backup window (hh24:mi-hh24:mi format)
  maintenance_window      = "mon:04:00-mon:04:30" # Preferred UTC maintenance window

  # Enable automated backups
  final_snapshot_identifier = "mysql-server"
  tags = {

    Name        = "MySql_DB_EKS",
    Environment = "Production",
  }
}



resource "aws_db_subnet_group" "_RDS_Subnet" {
  name       = "mysql_subnet_group"
  subnet_ids = [aws_subnet._prSubnet_1.id, aws_subnet._prSubnet_2.id]

  tags = {
    Name = "MySQL DB subnet group"
  }
}

output "rds_endpoint" {
  value = aws_db_instance._mysql.endpoint
}




# resource "null_resource" "run_sql_schema" {
#   depends_on = [aws_db_instance._mysql]

#   provisioner "local-exec" {
#     command = <<EOT
#       mysql -h ${aws_db_instance._mysql.endpoint} -u ${var.DB-admin} -p'${var.DB-password}' < Databse_contente/table-set.sql
#     EOT
#   }
# }