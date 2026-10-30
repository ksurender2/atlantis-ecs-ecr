# ==============================================================================
# KEYWORD EXPLANATION:
# - 'aws_security_group': Virtual firewall controlling network traffic for AWS resources.
# - 'ingress': Inbound network traffic rules (traffic coming IN).
# - 'egress': Outbound network traffic rules (traffic going OUT).
# - 'from_port' / 'to_port': Port range specified (e.g. Port 80 for HTTP, Port 3000 for Node.js).
# - 'protocol = "tcp"': Network protocol specification.
# - 'cidr_blocks = ["0.0.0.0/0"]': Allows access from any IP address on the public internet.
# ==============================================================================

# Create new ALB Security Group if no existing SG ID was passed
resource "aws_security_group" "alb" {
  count       = var.existing_alb_security_group_id == "" ? 1 : 0
  name        = var.alb_sg_name
  description = "Security Group for Application Load Balancer"
  vpc_id      = var.vpc_id

  # Allow HTTP port 80 traffic from any IP
  ingress {
    description      = "Allow public inbound traffic on port 80"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  # Allow all outbound internet traffic
  egress {
    description      = "Allow all outbound traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(var.tags, { Name = var.alb_sg_name })
}

# Create new Task Security Group if no existing SG ID was passed
resource "aws_security_group" "task" {
  count       = var.existing_task_security_group_id == "" ? 1 : 0
  name        = var.task_sg_name
  description = "Security Group for ECS Fargate Container Tasks"
  vpc_id      = var.vpc_id

  # Allow container port 3000 traffic from the ALB
  ingress {
    description     = "Allow inbound traffic on port 3000 from ALB"
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [local.alb_sg_id]
  }

  # Allow all outbound internet traffic (needed to download images & secrets)
  egress {
    description      = "Allow all outbound traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(var.tags, { Name = var.task_sg_name })
}

locals {
  alb_sg_id  = var.existing_alb_security_group_id != "" ? var.existing_alb_security_group_id : (length(aws_security_group.alb) > 0 ? aws_security_group.alb[0].id : "")
  task_sg_id = var.existing_task_security_group_id != "" ? var.existing_task_security_group_id : (length(aws_security_group.task) > 0 ? aws_security_group.task[0].id : "")
}
