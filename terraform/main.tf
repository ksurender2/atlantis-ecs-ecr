# ==============================================================================
# KEYWORD EXPLANATION:
# - 'module': A reusable building block (folder of .tf files) that provisions specific infrastructure.
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. S3 Backend Module
# KEYWORDS:
# - 'module "s3_backend"': Declares a module instance named "s3_backend".
# - 'count': Conditional logic. (var.create_s3_backend ? 1 : 0) creates 1 instance if true, 0 if false.
# - 'source': Local file path pointing to the module folder containing its code.
# ------------------------------------------------------------------------------
module "s3_backend" {
  count  = var.create_s3_backend ? 1 : 0
  source = "./modules/s3_backend"

  bucket_name         = var.s3_backend_bucket_name
  dynamodb_table_name = var.dynamodb_table_name
  tags                = var.tags
}

# ------------------------------------------------------------------------------
# 2. VPC Networking Module
# KEYWORDS:
# - 'vpc_id': Input variable passing your existing AWS VPC ID.
# - 'existing_public_subnet_ids': Input variable passing public subnet IDs.
# ------------------------------------------------------------------------------
module "vpc" {
  source = "./modules/vpc"

  vpc_id                     = var.vpc_id
  existing_public_subnet_ids = var.public_subnet_ids
  tags                       = var.tags
}

# ------------------------------------------------------------------------------
# 3. Security Groups (Firewalls) Module
# KEYWORDS:
# - 'module.vpc.vpc_id': Module Output Reference. Reads the vpc_id output exported by the VPC module.
# ------------------------------------------------------------------------------
module "security_groups" {
  source = "./modules/security_groups"

  vpc_id                          = module.vpc.vpc_id
  existing_alb_security_group_id  = var.existing_alb_security_group_id
  existing_task_security_group_id = var.existing_task_security_group_id
  alb_sg_name                     = var.alb_sg_name
  task_sg_name                    = var.task_sg_name
  tags                            = var.tags
}

# ------------------------------------------------------------------------------
# 4. Amazon ECR Container Registry Module
# KEYWORDS:
# - 'repository_name': Sets the private Docker image repository name in ECR.
# ------------------------------------------------------------------------------
module "ecr" {
  source = "./modules/ecr"

  repository_name = var.ecr_repository_name
  tags            = var.tags
}

# ------------------------------------------------------------------------------
# 5. AWS Secrets Manager Module
# KEYWORDS:
# - 'secret_name': Name identifier for encrypted secret in Secrets Manager.
# - 'secret_values': Map of sensitive key-value pairs (e.g. DATABASE_PASSWORD).
# ------------------------------------------------------------------------------
module "secrets_manager" {
  source = "./modules/secrets_manager"

  secret_name   = var.secret_name
  secret_values = var.secret_values
  tags          = var.tags
}

# ------------------------------------------------------------------------------
# 6. AWS IAM Roles & Policies Module
# KEYWORDS:
# - 'execution_role_name': Role name used by ECS Fargate agent to pull images & secrets.
# - 'task_role_name': Role name used by container code & SSM interactive shell.
# - 'secret_arn': Reference to Secret ARN created by secrets_manager module.
# ------------------------------------------------------------------------------
module "iam" {
  source = "./modules/iam"

  execution_role_name = var.execution_role_name
  task_role_name      = var.task_role_name
  secret_arn          = module.secrets_manager.secret_arn
  tags                = var.tags
}

# ------------------------------------------------------------------------------
# 7. Application Load Balancer (ALB) Module
# KEYWORDS:
# - 'public_subnet_ids': Subnet IDs where the Load Balancer will be deployed.
# - 'alb_security_group_id': Firewall SG ID attached to Load Balancer.
# ------------------------------------------------------------------------------
module "alb" {
  source = "./modules/alb"

  alb_name              = var.alb_name
  target_group_name     = var.target_group_name
  vpc_id                = module.vpc.vpc_id
  public_subnet_ids     = module.vpc.public_subnet_ids
  alb_security_group_id = module.security_groups.alb_security_group_id
  container_port        = var.container_port
  tags                  = var.tags
}

# ------------------------------------------------------------------------------
# 8. AWS ECS Fargate Cluster, Task & Service Module
# KEYWORDS:
# - 'container_image': Docker image URI. (var.container_image != "" ? ... : ...) is a ternary conditional operator.
# - 'valueFrom': Tells ECS Agent to pull decrypted secret values from AWS Secrets Manager.
# - 'depends_on': Explicit dependency ordering. Ensures ALB listener exists before ECS service attaches targets.
# ------------------------------------------------------------------------------
module "ecs" {
  source = "./modules/ecs"

  cluster_name          = var.cluster_name
  service_name          = var.service_name
  task_family           = var.task_family
  container_name        = var.container_name
  container_image       = var.container_image != "" ? var.container_image : "${module.ecr.repository_url}:latest"
  container_port        = var.container_port
  cpu                   = var.cpu
  memory                = var.memory
  desired_count         = var.desired_count
  subnet_ids            = module.vpc.public_subnet_ids
  security_group_ids    = [module.security_groups.task_security_group_id]
  target_group_arn      = module.alb.target_group_arn
  execution_role_arn    = module.iam.execution_role_arn
  task_role_arn         = module.iam.task_role_arn
  environment_variables = var.environment_variables
  secret_arn            = module.secrets_manager.secret_arn
  secret_keys           = var.secret_keys
  tags                  = var.tags

  depends_on = [module.alb.http_listener]
}
