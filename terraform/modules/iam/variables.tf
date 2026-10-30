variable "execution_role_name" {
  description = "Name of the ECS Task Execution Role"
  type        = string
  default     = "ecsTaskExecutionRole"
}

variable "task_role_name" {
  description = "Name of the ECS Task Role"
  type        = string
  default     = "ecsTaskRole"
}

variable "secret_arn" {
  description = "ARN of the Secrets Manager secret that Execution Role needs access to"
  type        = string
}

variable "tags" {
  description = "Map of tags to apply to resources"
  type        = map(string)
  default     = {}
}
