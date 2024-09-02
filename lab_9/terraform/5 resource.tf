resource "aws_instance" "entity" {
  ami           = "ami-096ea6a12ea24a797"
  instance_type = "t4g.small"
  vpc_security_group_ids = [aws_security_group.entity_sg.id]
  key_name      = local.aws_key.file_name


  tags = {
    Name = "${local.entity_name} Instance"
  }
}
