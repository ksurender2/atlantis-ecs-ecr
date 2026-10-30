# ==============================================================================
# KEYWORD EXPLANATION:
# - 'resource': Defines a managed AWS infrastructure object (e.g. S3 Bucket, DynamoDB Table).
# - 'aws_s3_bucket': Resource type for Amazon Simple Storage Service (S3) bucket.
# - 'force_destroy': Allows Terraform to delete bucket contents when destroying if true.
# - 'aws_s3_bucket_versioning': Enables file revision history in S3 (restores old state files if modified).
# - 'aws_s3_bucket_server_side_encryption_configuration': Encrypts all stored state files using AES256.
# - 'aws_s3_bucket_public_access_block': Blocks all public internet access to secure sensitive state file.
# - 'aws_dynamodb_table': Resource type for DynamoDB NoSQL database table used for state locking.
# - 'billing_mode = "PAY_PER_REQUEST"': On-demand pricing mode (no fixed monthly charges).
# - 'hash_key = "LockID"': Sets 'LockID' as primary partition key required by Terraform backend.
# ==============================================================================

resource "aws_s3_bucket" "state" {
  bucket        = var.bucket_name
  force_destroy = false
  tags          = merge(var.tags, { Name = var.bucket_name })

  # This bucket holds this project's own state; never let a plan destroy it.
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "state" {
  bucket = aws_s3_bucket.state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "state" {
  bucket = aws_s3_bucket.state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "state" {
  bucket                  = aws_s3_bucket.state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "locks" {
  name         = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S" # 'S' stands for String data type
  }

  tags = merge(var.tags, { Name = var.dynamodb_table_name })

  lifecycle {
    prevent_destroy = true
  }
}
