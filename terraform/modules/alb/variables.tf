variable "alb_name" {
  description = "Name of the Application Load Balancer"
  type        = string
  default     = "ecs-secrets-alb"
}

variable "target_group_name" {
  description = "Name of the target group"
  type        = string
  default     = "ecs-secrets-tg"
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs to attach the ALB to"
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "ID of the ALB security group"
  type        = string
}

variable "container_port" {
  description = "Target port for container traffic"
  type        = number
  default     = 3000
}

variable "health_check_path" {
  description = "HTTP path for target group health checks"
  type        = string
  default     = "/health"
}

variable "tags" {
  description = "Map of tags to apply to resources"
  type        = map(string)
  default     = {}
}
