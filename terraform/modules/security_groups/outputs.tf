# ==============================================================================
# KEYWORD EXPLANATION:
# - 'output': Exports security group IDs from the module.
# ==============================================================================

output "alb_security_group_id" {
  description = "ID of the Application Load Balancer Security Group"
  value       = local.alb_sg_id
}

output "task_security_group_id" {
  description = "ID of the Fargate Task Security Group"
  value       = local.task_sg_id
}
