# ==============================================================================
# KEYWORD EXPLANATION:
# - 'output': Exports values from the VPC module to the root module.
# ==============================================================================

output "vpc_id" {
  description = "ID of the Virtual Private Cloud (VPC)"
  value       = var.vpc_id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs in the VPC"
  value       = local.public_subnet_ids
}
