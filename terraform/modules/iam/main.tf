# ==============================================================================
# KEYWORD EXPLANATION:
# - 'aws_iam_role': Identity and Access Management role granting AWS permissions to services.
# - 'assume_role_policy': Trust policy allowing 'ecs-tasks.amazonaws.com' service to assume this role.
# - 'aws_iam_role_policy_attachment': Attaches standard AWS managed IAM policy ARNs to the role.
# - 'aws_iam_role_policy': Creates inline custom IAM permission policy attached directly to the role.
# ==============================================================================

# 1. ECS Task Execution Role (used by AWS ECS Agent to pull images from ECR & secrets from Secrets Manager)
resource "aws_iam_role" "execution_role" {
  name = var.execution_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(var.tags, { Name = var.execution_role_name })
}

# Attach standard AmazonECSTaskExecutionRolePolicy (ECR image pull & CloudWatch logging)
resource "aws_iam_role_policy_attachment" "execution_role_policy" {
  role       = aws_iam_role.execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Attach inline policy allowing Execution Role to read AWS Secrets Manager secret value
resource "aws_iam_role_policy" "secrets_manager_access" {
  name = "ECSSecretsManagerAccessPolicy"
  role = aws_iam_role.execution_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowGetSecretValue"
        Effect = "Allow"
        Action = ["secretsmanager:GetSecretValue"]
        Resource = [
          var.secret_arn,
          "${var.secret_arn}*"
        ]
      }
    ]
  })
}

# 2. ECS Task Role (used by container application code & interactive ECS Exec shell)
resource "aws_iam_role" "task_role" {
  name = var.task_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(var.tags, { Name = var.task_role_name })
}

# Attach AmazonSSMManagedInstanceCore to allow interactive ECS Exec debugging shell
resource "aws_iam_role_policy_attachment" "task_role_ssm" {
  role       = aws_iam_role.task_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
