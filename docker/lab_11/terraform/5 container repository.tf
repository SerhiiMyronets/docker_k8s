# resource "aws_ecr_repository" "simple-node" {
#   name = "goals-node"
#
#   image_tag_mutability = "MUTABLE"
#
#   image_scanning_configuration {
#     scan_on_push = true
#   }
# }