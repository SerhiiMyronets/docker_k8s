resource "aws_ecs_task_definition" "main" {

  family             = "goals"
  network_mode       = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                = "512"
  memory             = "1024"
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  runtime_platform {
    cpu_architecture        = "ARM64"
    operating_system_family = "LINUX"
  }

  container_definitions = jsonencode([
    {
      name      = "goals-backend"
      image     = "serhiimyronets/multi_app"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          name : "node-goals-80-tcp",
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
          appProtocol : "http"
        },
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/example-task"
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "ecs"
        }
      }
      environment = [
        {
          name  = "MONGODB_USERNAME"
          value = "goals"
        },
        {
          name  = "MONGODB_PASSWORD"
          value = "PENftieSqLRIu0CV"
        },
        {
          name  = "MONGODB_URL"
          value = "cluster0.ar0jw.mongodb.net"
        },
        {
          name  = "MONGODB_NAME"
          value = "goals"
        }
      ]
      command : ["node", "app.js"]
    }
  ])
}


resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
      },
    ],
  })
}

resource "aws_iam_policy_attachment" "ecs_task_execution" {
  name       = "ecsTaskExecutionRole"
  roles = [aws_iam_role.ecs_task_execution_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_policy_attachment" "ecr_access" {
  name       = "ecsTaskECRAccess"
  roles = [aws_iam_role.ecs_task_execution_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_policy_attachment" "ecs_task_execution_policy_attachment" {
  name       = "ecsTaskExecutionPolicyAttachment"
  roles = [aws_iam_role.ecs_task_execution_role.name]
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

resource "aws_iam_policy_attachment" "efs_access" {
  name       = "ecsTaskEFSMountAccess"
  roles = [aws_iam_role.ecs_task_execution_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonElasticFileSystemClientReadWriteAccess"
}

resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/example-task"
  retention_in_days = 7
}

