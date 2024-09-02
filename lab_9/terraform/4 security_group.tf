resource "aws_security_group" "entity_sg" {
  name = "${local.entity_name} security group"

  dynamic "ingress" {
    for_each = local.ingress_rules.port
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = local.ingress_rules.protocol
      cidr_blocks = local.ingress_rules.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = local.egress_rules.port
    content {
      from_port   = egress.value
      to_port     = egress.value
      protocol    = local.egress_rules.protocol
      cidr_blocks = local.egress_rules.cidr_blocks
    }
  }
}
