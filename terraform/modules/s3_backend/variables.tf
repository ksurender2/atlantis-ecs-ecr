variable "bucket_name" {
  description = "Name of the S3 bucket to store Terraform state files"
  type        = string
  default     = "ecs-secrets-tf-state-bucket"
}

variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table for state locking"
  type        = string
  default     = "terraform-state-locks"
}

variable "tags" {
  description = "Map of tags to apply to resources"
  type        = map(string)
  default     = {}
}
