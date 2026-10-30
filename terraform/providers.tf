# ==============================================================================
# KEYWORD EXPLANATION:
# - 'terraform': Top-level block setting global Terraform settings and provider constraints.
# - 'required_version': Enforces minimum Terraform CLI version required (>= 1.3.0).
# - 'required_providers': Declares external cloud provider plugins downloaded from HashiCorp Registry.
# - 'provider "aws"': Configures authentication and regional settings for Amazon Web Services.
# - 'default_tags': Automatically attaches standard metadata tags to every resource created by this provider.
# ==============================================================================
terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile != "" ? var.aws_profile : null

  default_tags {
    tags = var.tags
  }
}
