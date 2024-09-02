locals {
  entity_name = "web-app"
  ingress_rules = {
    port = ["22", "80"],
    protocol = "tcp",
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress_rules = {
    port = ["22", "80", "443"],
    protocol = "tcp",
    cidr_blocks = ["0.0.0.0/0"]
  }
}
