variable "cluster_name" {
  description = "Name of the ECS Cluster"
  type        = string
  default     = "ecs-secrets-cluster"
}

variable "service_name" {
  description = "Name of the ECS Fargate Service"
  type        = string
  default     = "ecs-secrets-service"
}

variable "task_family" {
  description = "Task definition family name"
  type        = string
  default     = "ecs-secrets-demo-task"
}

variable "execution_role_arn" {
  description = "ARN of the ECS Execution Role"
  type        = string
}

variable "task_role_arn" {
  description = "ARN of the ECS Task Role"
  type        = string
}

variable "container_name" {
  description = "Name of the container inside the task definition"
  type        = string
  default     = "ecs-secrets-app"
}

variable "container_image" {
  description = "Full Docker image URI (including registry tag)"
  type        = string
}

variable "container_port" {
  description = "Port on which container listens"
  type        = number
  default     = 3000
}

variable "cpu" {
  description = "Fargate Task CPU units (e.g. 256 for 0.25 vCPU)"
  type        = string
  default     = "256"
}

variable "memory" {
  description = "Fargate Task Memory in MB (e.g. 512 for 0.5 GB)"
  type        = string
  default     = "512"
}

variable "desired_count" {
  description = "Number of parallel tasks to run in the ECS service"
  type        = number
  default     = 2
}

variable "environment_variables" {
  description = "Map of plaintext environment variables"
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
  description = "List of JSON keys inside the Secrets Manager secret to expose as environment variables"
  type        = list(string)
  default     = ["DATABASE_PASSWORD", "API_SECRET_KEY", "SECRET_SOURCE"]
}

variable "secret_arn" {
  description = "ARN of the Secrets Manager secret"
  type        = string
}

variable "subnet_ids" {
  description = "Subnets to deploy Fargate tasks into"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security groups to attach to Fargate tasks"
  type        = list(string)
}

variable "target_group_arn" {
  description = "Target Group ARN for load balancer integration"
  type        = string
}

variable "log_group_name" {
  description = "CloudWatch Log Group name"
  type        = string
  default     = "/ecs/ecs-secrets-demo"
}

variable "aws_region" {
  description = "AWS Region where logs and resources are deployed"
  type        = string
  default     = "us-east-1"
}

variable "assign_public_ip" {
  description = "Assign public IP address to Fargate tasks"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Map of tags to apply to resources"
  type        = map(string)
  default     = {}
}
