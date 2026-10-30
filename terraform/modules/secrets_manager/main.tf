# ==============================================================================
# KEYWORD EXPLANATION:
# - 'aws_secretsmanager_secret': Encrypted secret vault resource in AWS Secrets Manager.
# - 'recovery_window_in_days = 0': Forces immediate deletion when destroyed without 30-day waiting period.
# - 'aws_secretsmanager_secret_version': Stores the actual encrypted JSON payload of secrets.
# ==============================================================================

resource "aws_secretsmanager_secret" "app" {
  name                    = var.secret_name
  recovery_window_in_days = 0

  tags = merge(var.tags, { Name = var.secret_name })
}

# Injects secret values as encrypted JSON object
resource "aws_secretsmanager_secret_version" "app" {
  secret_id     = aws_secretsmanager_secret.app.id
  secret_string = jsonencode(var.secret_values)
}
