resource "aws_security_group" "entity_sg" {
  name   = "${local.entity_name} security group"
  vpc_id = aws_vpc.entity_vpc.id

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "efs_sg" {
  name   = "${local.entity_name} efs security group"
  vpc_id = aws_vpc.entity_vpc.id

  ingress {
    from_port = 2049
    to_port   = 2049
    protocol  = "tcp"
    security_groups = [aws_security_group.entity_sg.id]
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "goal-lb" {
  name               = "goal-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.entity_sg.id]
  subnets            = aws_subnet.entity_public_subnets[*].id

  enable_deletion_protection = false
}


resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.goal-lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.goal-tg.arn
  }
}
resource "aws_lb_target_group" "goal-tg" {
  name        = "goal-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.entity_vpc.id
  target_type = "ip"

  health_check {
    path                = "/goals"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
    matcher             = "200"
  }
}


locals {
  entity_name = "goals-app"
}
