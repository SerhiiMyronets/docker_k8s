resource "aws_ecs_service" "main" {

  name            = "goals-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.main.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets = aws_subnet.entity_public_subnets[*].id
    //concat(aws_subnet.entity_private_subnets[*].id, aws_subnet.entity_public_subnets[*].id)
    security_groups = [aws_security_group.entity_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.goal-tg.arn
    container_name   = "goals-backend"
    container_port   = 80
  }

  force_new_deployment = true

  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
}