variable "vpc_id" {
  description = "ID of the VPC where security groups will be created or attached"
  type        = string
}

variable "existing_alb_security_group_id" {
  description = "Optional ID of an existing ALB Security Group. If provided, creation of new ALB SG is skipped."
  type        = string
  default     = ""
}

variable "existing_task_security_group_id" {
  description = "Optional ID of an existing ECS Task Security Group. If provided, creation of new Task SG is skipped."
  type        = string
  default     = ""
}

variable "alb_sg_name" {
  description = "Name of the ALB security group (used if existing_alb_security_group_id is empty)"
  type        = string
  default     = "ecs-alb-sg"
}

variable "task_sg_name" {
  description = "Name of the ECS task security group (used if existing_task_security_group_id is empty)"
  type        = string
  default     = "ecs-task-sg"
}

variable "container_port" {
  description = "Port on which the application container listens"
  type        = number
  default     = 3000
}

variable "alb_ingress_ports" {
  description = "List of public ports to allow inbound traffic to ALB"
  type        = list(number)
  default     = [80]
}

variable "tags" {
  description = "Map of tags to apply to resources"
  type        = map(string)
  default     = {}
}
