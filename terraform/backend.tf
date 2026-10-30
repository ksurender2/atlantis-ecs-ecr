# ==============================================================================
# KEYWORD EXPLANATION:
# - 'backend "s3"': Tells Terraform to store infrastructure state remotely in AWS S3 instead of local disk.
# - 'bucket': Name of the S3 bucket storing state file.
# - 'key': Path inside S3 bucket where state JSON file is kept.
# - 'dynamodb_table': Name of DynamoDB table managing concurrent state locking.
# - 'encrypt': Encrypts state file at rest in S3 using AES256 server-side encryption.
# ==============================================================================
terraform {
  backend "s3" {
    bucket         = "ecs-secrets-tf-state-bucket"
    key            = "ecs-fargate-secrets/production/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}
