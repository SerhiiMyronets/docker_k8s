data "aws_ami" "latest_ubuntu_x64" {
  owners = ["099720109477"]
  most_recent = true
  filter {
    name = "description"
    values = ["Canonical, Ubuntu, 24.04 LTS, amd64*"]
  }
}

# data "aws_ami" "latest_amazon_arm" {
#   owners = ["amazon"]
#   most_recent = true
#   filter {
#     name = "description"
#     values = ["Canonical, Ubuntu, 24.04 LTS, amd64*"]
#   }
# }
data "aws_ec2_instance_types" "t2_small" {
  filter {
    name = "instance-type"
    values = ["t2.micro"]
  }
}

data "aws_vpc" "defaul" {
  default = true
}
data "aws_subnets" "default" {
  filter {
    name = "vpc-id"
    values = [data.aws_vpc.defaul.id]
  }
  filter {
    name = "default-for-az"
    values = [true]
  }
  filter {
    name = "state"
    values = ["available"]
  }
}
data "aws_subnet" "subnets_details" {
  for_each = toset(data.aws_subnets.default.ids)
  id = each.value
}
locals {
  all_subnets = data.aws_subnets.default.ids

  filtered_subnets = [
    for subnet_id in local.all_subnets : subnet_id
    if data.aws_subnet.subnets_details[subnet_id].availability_zone != "us-east-1e"
  ]
}
data "aws_subnet" "default" {
  for_each = {for index, subnetid in data.aws_subnets.default.ids : index => subnetid}
  id       = each.value
}
