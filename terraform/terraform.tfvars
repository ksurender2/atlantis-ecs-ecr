# ==============================================================================
# Global & Provider Configuration
# ==============================================================================
aws_region  = "us-east-1"
environment = "production"

tags = {
  Project   = "Terraform-ECS-ECR"
  ManagedBy = "Terraform"
  LabOwner  = "Surender Container Labs"
}

# ------------------------------------------------------------------------------
# 1. Existing AWS Networking (From your AWS VPC Console Screenshot)
# ------------------------------------------------------------------------------
vpc_id = "vpc-0f663c77917b63864"
public_subnet_ids = [
  "subnet-06bc4e0f3caf0ad42", # us-east-1a
  "subnet-09e2d8b0fe54a1445"  # us-east-1f
]
existing_alb_security_group_id  = ""
existing_task_security_group_id = "sg-0e4706edf39bc147b"

alb_sg_name  = "ecs-alb-sg"
task_sg_name = "ecs-task-sg"

# ------------------------------------------------------------------------------
# 2. S3 Backend Remote State Storage
# ------------------------------------------------------------------------------
create_s3_backend      = false # bucket and lock table already exist (bootstrapped); backend.tf depends on them
s3_backend_bucket_name = "ecs-secrets-tf-state-bucket"
dynamodb_table_name    = "terraform-state-locks"

# ------------------------------------------------------------------------------
# 3. Amazon ECR & AWS Secrets Manager Names
# ------------------------------------------------------------------------------
ecr_repository_name = "ecs-secrets-demo"
secret_name         = "ecs/demo/app-secrets"
# secret_values is NOT stored here: set it locally in secrets.auto.tfvars (gitignored)
# and on the Atlantis server via the TF_VAR_secret_values environment variable.

# ------------------------------------------------------------------------------
# 4. IAM Roles Setup (Unique Role Names to Avoid Collision)
# ------------------------------------------------------------------------------
execution_role_name = "ecsSecretsDemoExecutionRole"
task_role_name      = "ecsSecretsDemoTaskRole"

# ------------------------------------------------------------------------------
# 5. Load Balancer Names
# ------------------------------------------------------------------------------
alb_name          = "ecs-secrets-alb"
target_group_name = "ecs-secrets-tg"

# ------------------------------------------------------------------------------
# 6. ECS Fargate Service & Task Sizing (8GB RAM / 2 vCPU)
# ------------------------------------------------------------------------------
cluster_name   = "ecs-secrets-cluster"
service_name   = "ecs-secrets-service"
task_family    = "ecs-secrets-demo-task"
container_name = "ecs-secrets-app"
container_port = 3000

# Sizing: 2 vCPU and 8GB RAM (8192 MB)
cpu           = "2048" # 2 vCPU
memory        = "8192" # 8 GB RAM
desired_count = 2      # Runs 2 container tasks for load balancing

# Plaintext Environment Variables
environment_variables = {
  APP_NAME          = "AWS ECS Fargate Production App (Terraform)"
  APP_ENV           = "production"
  PORT              = "3000"
  LOG_LEVEL         = "info"
  FEATURE_ANALYTICS = "enabled"
}

# Secret Keys in Secrets Manager JSON object
secret_keys = [
  "DATABASE_PASSWORD",
  "API_SECRET_KEY",
  "SECRET_SOURCE"
]
