output "s3_bucket_name" {
  description = "Name of the created S3 backend bucket"
  value       = aws_s3_bucket.state.id
}

output "s3_bucket_arn" {
  description = "ARN of the S3 backend bucket"
  value       = aws_s3_bucket.state.arn
}

output "dynamodb_table_name" {
  description = "Name of the DynamoDB state locking table"
  value       = aws_dynamodb_table.locks.name
}

output "dynamodb_table_arn" {
  description = "ARN of the DynamoDB state locking table"
  value       = aws_dynamodb_table.locks.arn
}
