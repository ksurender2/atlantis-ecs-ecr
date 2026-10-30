variable "secret_name" {
  description = "Name of the AWS Secrets Manager secret"
  type        = string
  default     = "ecs/demo/app-secrets"
}

variable "secret_values" {
  description = "Map of key-value secrets to be stored as JSON"
  type        = map(string)
  default = {
    DATABASE_PASSWORD = "prod_super_secure_db_pass_2026!"
    API_SECRET_KEY    = "sk_live_99008877665544332211"
    SECRET_SOURCE     = "AWS Secrets Manager (Terraform Provisioned)"
  }
}

variable "tags" {
  description = "Map of tags to apply to resources"
  type        = map(string)
  default     = {}
}
