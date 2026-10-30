variable "vpc_id" {
  description = "Optional ID of an existing VPC. If provided, creation of a new VPC is skipped."
  type        = string
  default     = ""
}

variable "existing_public_subnet_ids" {
  description = "Optional list of existing public subnet IDs if vpc_id is provided."
  type        = list(string)
  default     = []
}

variable "existing_private_subnet_ids" {
  description = "Optional list of existing private subnet IDs if vpc_id is provided."
  type        = list(string)
  default     = []
}

variable "vpc_cidr" {
  description = "CIDR block for the new VPC (used if vpc_id is empty)"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for new public subnets (used if vpc_id is empty)"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for new private subnets (used if vpc_id is empty)"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "availability_zones" {
  description = "List of availability zones for subnet deployment"
  type        = list(string)
  default     = []
}

variable "name_prefix" {
  description = "Prefix applied to name tags of resources"
  type        = string
  default     = "ecs-secrets-demo"
}

variable "enable_nat_gateway" {
  description = "Whether to provision NAT Gateways for private subnets"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Map of tags to apply to all resources"
  type        = map(string)
  default     = {}
}
