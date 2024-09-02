# # variable "node_backend_image" {
# #   default = "058264369873.dkr.ecr.us-east-1.amazonaws.com/goals-node"
# # }
#
# provider "aws" {
#   region = "us-west-2"
# }
#
# # Створення VPC
# resource "aws_vpc" "my_vpc" {
#   cidr_block           = "10.0.0.0/16"
#   enable_dns_support   = true
#   enable_dns_hostnames = true
#   tags = {
#     Name = "my_vpc"
#   }
# }
#
# # Створення Інтернет-шлюзу
# resource "aws_internet_gateway" "my_igw" {
#   vpc_id = aws_vpc.my_vpc.id
#   tags = {
#     Name = "my_igw"
#   }
# }
#
# # Публічна підмережа
# resource "aws_subnet" "public_subnet" {
#   vpc_id                  = aws_vpc.my_vpc.id
#   cidr_block              = "10.0.1.0/24"
#   map_public_ip_on_launch = true
#   availability_zone       = "us-west-2a"
#   tags = {
#     Name = "public_subnet"
#   }
# }
#
# # Приватна підмережа
# resource "aws_subnet" "private_subnet" {
#   vpc_id            = aws_vpc.my_vpc.id
#   cidr_block        = "10.0.2.0/24"
#   availability_zone = "us-west-2a"
#   tags = {
#     Name = "private_subnet"
#   }
# }
#
# # Таблиця маршрутизації
# resource "aws_route_table" "public_route_table" {
#   vpc_id = aws_vpc.my_vpc.id
#   tags = {
#     Name = "public_route_table"
#   }
# }
#
# # Маршрут до Інтернету
# resource "aws_route" "internet_access" {
#   route_table_id         = aws_route_table.public_route_table.id
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id             = aws_internet_gateway.my_igw.id
# }
#
# # Асоціація таблиці маршрутизації з публічною підмережею
# resource "aws_route_table_association" "public_subnet_association" {
#   subnet_id      = aws_subnet.public_subnet.id
#   route_table_id = aws_route_table.public_route_table.id
# }
#
# # NAT Gateway для приватної підмережі (опціонально)
# resource "aws_eip" "nat_eip" {
#   vpc = true
# }
#
# resource "aws_nat_gateway" "nat_gw" {
#   allocation_id = aws_eip.nat_eip.id
#   subnet_id     = aws_subnet.public_subnet.id
#   tags = {
#     Name = "nat_gw"
#   }
# }
#
# # Таблиця маршрутизації для приватної підмережі (опціонально)
# resource "aws_route_table" "private_route_table" {
#   vpc_id = aws_vpc.my_vpc.id
#   tags = {
#     Name = "private_route_table"
#   }
# }
#
# # Маршрут через NAT Gateway
# resource "aws_route" "private_route" {
#   route_table_id         = aws_route_table.private_route_table.id
#   destination_cidr_block = "0.0.0.0/0"
#   nat_gateway_id         = aws_nat_gateway.nat_gw.id
# }
#
# # Асоціація таблиці маршрутизації з приватною підмережею (опціонально)
# resource "aws_route_table_association" "private_subnet_association" {
#   subnet_id      = aws_subnet.private_subnet.id
#   route_table_id = aws_route_table.private_route_table.id
# }