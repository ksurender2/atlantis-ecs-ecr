# ==============================================================================
# KEYWORD EXPLANATION:
# - 'data': Queries existing infrastructure resources created outside Terraform in your AWS account.
# - 'aws_vpc': Data source lookup for an existing Virtual Private Cloud.
# - 'aws_subnets': Data source lookup listing all subnets associated with the VPC.
# - 'locals': Defines local temporary calculation variables used within this module.
# - 'length()': Built-in Terraform function calculating array length.
# ==============================================================================

# Data lookup to query existing VPC details
data "aws_vpc" "existing" {
  count = var.vpc_id != "" ? 1 : 0
  id    = var.vpc_id
}

# Data lookup to query existing subnets in the VPC
data "aws_subnets" "vpc_subnets" {
  count = var.vpc_id != "" && length(var.existing_public_subnet_ids) < 2 ? 1 : 0

  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

locals {
  # Selects provided subnets or falls back to querying all subnets in the VPC
  public_subnet_ids = length(var.existing_public_subnet_ids) >= 2 ? var.existing_public_subnet_ids : (
    length(data.aws_subnets.vpc_subnets) > 0 ? data.aws_subnets.vpc_subnets[0].ids : []
  )
}
