# ==============================================================================
# KEYWORD EXPLANATION:
# - 'aws_ecr_repository': Amazon Elastic Container Registry (ECR) repository for Docker images.
# - 'image_tag_mutability = "MUTABLE"': Allows pushing image updates with the same tag (e.g. :latest).
# - 'scan_on_push = true': Automatically scans uploaded Docker images for security vulnerabilities.
# - 'aws_ecr_lifecycle_policy': Retention rule automatically cleaning up old image tags.
# - 'jsonencode()': Converts native HCL map/list structures into formatted JSON string format.
# ==============================================================================

resource "aws_ecr_repository" "app" {
  name                 = var.repository_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = merge(var.tags, { Name = var.repository_name })
}

# Lifecycle policy keeping only the last 10 pushed Docker images to save storage cost
resource "aws_ecr_lifecycle_policy" "policy" {
  repository = aws_ecr_repository.app.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 10 container images"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 10
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}
