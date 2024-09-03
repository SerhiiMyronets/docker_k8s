resource "aws_vpc" "entity_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = { name = "${local.entity_name} vpc" }
}


data "aws_availability_zones" "available" {}

resource "aws_subnet" "entity_public_subnets" {
  count = 2//length(data.aws_availability_zones.available.names)
  vpc_id                  = aws_vpc.entity_vpc.id
  cidr_block = cidrsubnet(aws_vpc.entity_vpc.cidr_block, 8, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = { name = "${local.entity_name} public subnet ${count.index}" }
}

resource "aws_internet_gateway" "entity_vpc_gw" {
  vpc_id = aws_vpc.entity_vpc.id
  tags = { name = "${local.entity_name} vpc internet gateway" }
}

resource "aws_route" "default" {
  route_table_id         = aws_vpc.entity_vpc.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.entity_vpc_gw.id
}

# resource "aws_route_table" "entity_rtb_public" {
#   vpc_id = aws_vpc.entity_vpc.id
#   tags = { name = "${local.entity_name} public subnet route table" }
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.entity_vpc_gw.id
#   }
# }



# resource "aws_route_table_association" "public_subnet_association" {
#   count = length(aws_subnet.entity_public_subnets)
#   subnet_id      = aws_subnet.entity_public_subnets[count.index].id
#   route_table_id = aws_vpc.entity_vpc.default_route_table_id//aws_route_table.entity_rtb_public.id
# }

# resource "aws_subnet" "entity_private_subnets" {
#   count = length(data.aws_availability_zones.available.names)
#   vpc_id            = aws_vpc.entity_vpc.id
#   cidr_block = cidrsubnet(aws_vpc.entity_vpc.cidr_block, 8, count.index + length(data.aws_availability_zones.available.names))
#   availability_zone = data.aws_availability_zones.available.names[count.index]
#   tags = { name = "${local.entity_name} private subnet ${count.index}" }
# }

# resource "aws_eip" "nat_eip" {}
#
# resource "aws_nat_gateway" "nat_gw" {
#   allocation_id = aws_eip.nat_eip.id
#   subnet_id     = aws_subnet.entity_public_subnets[0].id
#   tags = {
#     Name = "nat_gw"
#   }
# }

# resource "aws_route_table" "private_route_table" {
#   vpc_id = aws_vpc.entity_vpc.id
#   tags = {
#     Name = "private_route_table"
#   }
# }

# resource "aws_route" "private_route" {
#   route_table_id         = aws_route_table.private_route_table.id
#   destination_cidr_block = "0.0.0.0/0"
#   nat_gateway_id         = aws_nat_gateway.nat_gw.id
# }

# resource "aws_route_table_association" "private_subnet_association" {
#   count = length(aws_subnet.entity_private_subnets)
#   subnet_id      = aws_subnet.entity_private_subnets[count.index].id
#   route_table_id = aws_route_table.private_route_table.id
# }
#
# output "as" {
#   value = concat(aws_subnet.entity_private_subnets[*].id, aws_subnet.entity_public_subnets[*].id)
# }