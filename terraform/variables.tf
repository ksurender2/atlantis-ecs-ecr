# ==============================================================================
# KEYWORD EXPLANATION:
# - 'variable': Declares an input parameter that customizable by users or tfvars files.
# - 'description': Human-readable explanation of what the variable controls.
# - 'type': Datatype constraint (string, number, bool, list(string), map(string)).
# - 'default': Fallback value if no explicit value is provided in terraform.tfvars.
# ==============================================================================

# ==============================================================================
# AWS Provider & Global Variables
# ==============================================================================
variable "aws_region" {
  description = "AWS region for infrastructure deployment (e.g. us-east-1)"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "AWS CLI named credential profile to use (e.g. default, myaws, prod)"
  type        = string
  default     = ""
}

variable "environment" {
  description = "Deployment environment classification (production, staging, dev)"
  type        = string
  default     = "production"
}

variable "tags" {
  description = "Map of key-value tags applied to all created AWS resources"
  type        = map(string)
  default = {
    Project   = "Terraform-ECS-ECR"
    ManagedBy = "Terraform"
    Owner     = "George Container Labs"
  }
}

# ==============================================================================
# Existing AWS Networking & Security Inputs (From AWS Console)
# ==============================================================================
variable "vpc_id" {
  description = "Existing VPC ID from AWS Console (e.g. vpc-0f663c77917b63864)"
  type        = string
  default     = "vpc-0f663c77917b63864"
}

variable "public_subnet_ids" {
  description = "List of existing public subnet IDs across Availability Zones"
  type        = list(string)
  default     = ["subnet-06bc4e0f3caf0ad42", "subnet-09e2d8b0fe54a1445"]
}

variable "existing_alb_security_group_id" {
  description = "Optional existing Security Group ID for Load Balancer"
  type        = string
  default     = ""
}

variable "existing_task_security_group_id" {
  description = "Optional existing Security Group ID for ECS Tasks (e.g. sg-0e4706edf39bc147b)"
  type        = string
  default     = "sg-0e4706edf39bc147b"
}

variable "alb_sg_name" {
  description = "Security Group name created for Load Balancer (used if creating new SG)"
  type        = string
  default     = "ecs-alb-sg"
}

variable "task_sg_name" {
  description = "Security Group name created for Fargate Tasks (used if creating new SG)"
  type        = string
  default     = "ecs-task-sg"
}

# ==============================================================================
# S3 Backend Remote State Variables
# ==============================================================================
variable "create_s3_backend" {
  description = "Boolean toggle. Set true to create S3 bucket and DynamoDB table for state locking."
  type        = bool
  default     = true
}

variable "s3_backend_bucket_name" {
  description = "Name of the S3 bucket for storing Terraform remote state"
  type        = string
  default     = "ecs-secrets-tf-state-bucket"
}

variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table for concurrent state locking"
  type        = string
  default     = "terraform-state-locks"
}

# ==============================================================================
# Amazon ECR & Secrets Manager Variables
# ==============================================================================
variable "ecr_repository_name" {
  description = "Amazon ECR Repository Name for storing Docker images"
  type        = string
  default     = "ecs-secrets-demo"
}

variable "secret_name" {
  description = "AWS Secrets Manager secret path name"
  type        = string
  default     = "ecs/demo/app-secrets"
}

variable "secret_values" {
  description = "Map of sensitive key-value secrets stored encrypted in AWS Secrets Manager"
  type        = map(string)
  sensitive   = true
}

# ==============================================================================
# IAM Roles Setup
# ==============================================================================
variable "execution_role_name" {
  description = "Name of the ECS Task Execution Role (used by ECS agent)"
  type        = string
  default     = "ecsSecretsDemoExecutionRole"
}

variable "task_role_name" {
  description = "Name of the ECS Task Role (used by app code & SSM interactive shell)"
  type        = string
  default     = "ecsSecretsDemoTaskRole"
}

# ==============================================================================
# Application Load Balancer Variables
# ==============================================================================
variable "alb_name" {
  description = "Name of the Application Load Balancer"
  type        = string
  default     = "ecs-secrets-alb"
}

variable "target_group_name" {
  description = "Name of the ALB Target Group"
  type        = string
  default     = "ecs-secrets-tg"
}

# ==============================================================================
# ECS Fargate Cluster, Task & Service Variables
# ==============================================================================
variable "cluster_name" {
  description = "Name of the Amazon ECS Cluster"
  type        = string
  default     = "ecs-secrets-cluster"
}

variable "service_name" {
  description = "Name of the ECS Fargate Service"
  type        = string
  default     = "ecs-secrets-service"
}

variable "task_family" {
  description = "ECS Task Definition Family Name"
  type        = string
  default     = "ecs-secrets-demo-task"
}

variable "container_name" {
  description = "Container identifier name inside the Task Definition"
  type        = string
  default     = "ecs-secrets-app"
}

variable "container_image" {
  description = "Docker container image URI in Amazon ECR"
  type        = string
  default     = ""
}

variable "container_port" {
  description = "Port exposed by the Node.js application container (3000)"
  type        = number
  default     = 3000
}

variable "cpu" {
  description = "Fargate CPU units (2048 = 2 vCPU)"
  type        = string
  default     = "2048"
}

variable "memory" {
  description = "Fargate Memory in Megabytes (8192 = 8 GB RAM)"
  type        = string
  default     = "8192"
}

variable "desired_count" {
  description = "Number of parallel Fargate container tasks to run behind ALB"
  type        = number
  default     = 2
}

variable "environment_variables" {
  description = "Map of plaintext environment variables injected into container"
  type        = map(string)
  default = {
    APP_NAME          = "AWS ECS Fargate Production App (Terraform)"
    APP_ENV           = "production"
    PORT              = "3000"
    LOG_LEVEL         = "info"
    FEATURE_ANALYTICS = "enabled"
  }
}

variable "secret_keys" {
  description = "List of secret keys in Secrets Manager JSON to inject as environment variables"
  type        = list(string)
  default     = ["DATABASE_PASSWORD", "API_SECRET_KEY", "SECRET_SOURCE"]
}
