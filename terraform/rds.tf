resource "aws_db_subnet_group" "db_subnet" {
    name = "main"
    subnet_ids = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
  
}

resource "aws_db_instance" "db" {
    allocated_storage = 10
    db_name = "db"
    engine = "mysql"
    instance_class = "db.t3.micro"
    username = "admin"
    password = random_password.db_password.result
    db_subnet_group_name = aws_db_subnet_group.db_subnet.name
    vpc_security_group_ids = [aws_security_group.rds_sg.id]
    skip_final_snapshot = true
}

resource "random_password" "db_password" {
  length  = 16
  special = true
}

