resource "aws_vpc" "ecs_vpc" {
  cidr_block= "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
}

resource "aws_internet_gateway" "public_igw" {
  vpc_id = aws_vpc.ecs_vpc.id
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id = aws_vpc.ecs_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-central-1a"
  map_public_ip_on_launch = true 
}
resource "aws_subnet" "public_subnet_2" {
  vpc_id = aws_vpc.ecs_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "eu-central-1b"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.ecs_vpc.id
  cidr_block = "10.0.10.0/24"
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.ecs_vpc.id
}

resource "aws_route" "internet_access" {
  route_table_id = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.public_igw.id
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.ecs_vpc.id
}

resource "aws_route_table_association" "public_assoc_1" {
  subnet_id = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}
resource "aws_route_table_association" "public_assoc_2" {
  subnet_id = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_subnet" {
  subnet_id = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id 
}


