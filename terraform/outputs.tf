# ==============================================================================
# KEYWORD EXPLANATION:
# - 'output': Exports values from the Terraform state after provisioning so users/scripts can consume them.
# - 'description': Explanation of what information the output represents.
# - 'value': The data expression exported (e.g. module.alb.alb_dns_name).
# ==============================================================================

output "alb_dns_name" {
  description = "Public DNS Name of the Application Load Balancer"
  value       = module.alb.alb_dns_name
}

output "alb_url" {
  description = "Clickable HTTP Web URL to open the application in browser"
  value       = "http://${module.alb.alb_dns_name}"
}

output "ecr_repository_url" {
  description = "Amazon ECR Docker Repository URI"
  value       = module.ecr.repository_url
}

output "secret_arn" {
  description = "AWS Secrets Manager Secret ARN"
  value       = module.secrets_manager.secret_arn
}

output "ecs_cluster_name" {
  description = "Name of the deployed ECS Cluster"
  value       = module.ecs.cluster_name
}

output "ecs_service_name" {
  description = "Name of the deployed ECS Fargate Service"
  value       = module.ecs.service_name
}

output "execution_role_arn" {
  description = "IAM Role ARN used by ECS Fargate Execution Role"
  value       = module.iam.execution_role_arn
}

output "task_role_arn" {
  description = "IAM Role ARN used by ECS Fargate Task Role"
  value       = module.iam.task_role_arn
}

output "s3_backend_bucket_name" {
  description = "Name of S3 Bucket storing remote state file"
  value       = length(module.s3_backend) > 0 ? module.s3_backend[0].s3_bucket_name : var.s3_backend_bucket_name
}

output "dynamodb_table_name" {
  description = "Name of DynamoDB table managing state locking"
  value       = length(module.s3_backend) > 0 ? module.s3_backend[0].dynamodb_table_name : var.dynamodb_table_name
}

output "docker_push_instructions" {
  description = "Step-by-step CLI commands to build, tag & push your Docker image to ECR"
  value       = <<EOT
1. Authenticate Docker with ECR:
   aws ecr get-login-password --region ${var.aws_region} --profile ${var.aws_profile} | docker login --username AWS --password-stdin ${module.ecr.repository_url}

2. Build Docker Image locally:
   docker build -t ${var.ecr_repository_name}:latest ./app

3. Tag & Push Docker Image to ECR:
   docker tag ${var.ecr_repository_name}:latest ${module.ecr.repository_url}:latest
   docker push ${module.ecr.repository_url}:latest

4. Trigger ECS Deployment Update:
   aws ecs update-service --cluster ${module.ecs.cluster_name} --service ${module.ecs.service_name} --force-new-deployment --region ${var.aws_region} --profile ${var.aws_profile}
EOT
}
