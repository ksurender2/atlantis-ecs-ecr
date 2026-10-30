# ==============================================================================
# KEYWORD EXPLANATION:
# - 'aws_cloudwatch_log_group': Stores application stdout/stderr logs from Fargate containers.
# - 'aws_ecs_cluster': Logical grouping of Fargate container tasks.
# - 'aws_ecs_task_definition': Blueprint template defining container image, CPU, RAM, ports & secrets.
# - 'requires_compatibilities = ["FARGATE"]': Specifies serverless Fargate execution mode.
# - 'network_mode = "awsvpc"': Gives each task its own dedicated Elastic Network Interface (ENI) & private IP.
# - 'valueFrom': ECS Agent secret reference ending with double colons ('::') to extract JSON secret key.
# - 'aws_ecs_service': Long-running service maintainer ensuring 2 desired tasks run continuously behind ALB.
# - 'enable_execute_command = true': Enables interactive SSM terminal shell access into running containers.
# ==============================================================================

# 1. CloudWatch Log Group
resource "aws_cloudwatch_log_group" "app" {
  name              = "/ecs/${var.container_name}"
  retention_in_days = 7

  tags = merge(var.tags, { Name = "/ecs/${var.container_name}" })
}

# 2. Amazon ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = var.cluster_name

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = merge(var.tags, { Name = var.cluster_name })
}

# 3. ECS Fargate Task Definition Blueprint
resource "aws_ecs_task_definition" "app" {
  family                   = var.task_family
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu    # 2048 = 2 vCPU
  memory                   = var.memory # 8192 = 8 GB RAM
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn

  container_definitions = jsonencode([
    {
      name      = var.container_name
      image     = var.container_image
      essential = true

      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
          protocol      = "tcp"
        }
      ]

      # Plaintext environment variables
      environment = [
        for k, v in var.environment_variables : {
          name  = k
          value = v
        }
      ]

      # Decrypted secrets from AWS Secrets Manager (Note trailing :: key syntax)
      secrets = [
        for key in var.secret_keys : {
          name      = key
          valueFrom = "${var.secret_arn}:${key}::"
        }
      ]

      # CloudWatch Logs configuration
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.app.name
          "awslogs-region"        = "us-east-1"
          "awslogs-stream-prefix" = "fargate"
        }
      }
    }
  ])

  tags = merge(var.tags, { Name = var.task_family })
}

# 4. ECS Fargate Service
resource "aws_ecs_service" "main" {
  name                   = var.service_name
  cluster                = aws_ecs_cluster.main.id
  task_definition        = aws_ecs_task_definition.app.arn
  desired_count          = var.desired_count
  launch_type            = "FARGATE"
  enable_execute_command = true # Enables AWS SSM ECS Exec shell

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = var.security_group_ids
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  tags = merge(var.tags, { Name = var.service_name })
}
