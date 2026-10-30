output "cluster_name" {
  description = "Name of the created ECS Cluster"
  value       = aws_ecs_cluster.main.name
}

output "cluster_arn" {
  description = "ARN of the ECS Cluster"
  value       = aws_ecs_cluster.main.arn
}

output "service_name" {
  description = "Name of the ECS Service"
  value       = aws_ecs_service.main.name
}

output "service_id" {
  description = "ID of the ECS Service"
  value       = aws_ecs_service.main.id
}

output "task_definition_arn" {
  description = "ARN of the registered ECS Task Definition"
  value       = aws_ecs_task_definition.app.arn
}

output "task_family" {
  description = "Family of the ECS Task Definition"
  value       = aws_ecs_task_definition.app.family
}
