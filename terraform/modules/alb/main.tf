# ==============================================================================
# KEYWORD EXPLANATION:
# - 'aws_lb': Application Load Balancer distributing public HTTP traffic across container tasks.
# - 'load_balancer_type = "application"': Layer 7 HTTP/HTTPS load balancer.
# - 'aws_lb_target_group': Destination pool tracking container instances and health.
# - 'target_type = "ip"': Required for Fargate awsvpc network mode (routes directly to container IP).
# - 'health_check': Periodic HTTP probe checking container health (Port 3000 /health endpoint).
# - 'aws_lb_listener': Port 80 listener forwarding web requests to target group pool.
# ==============================================================================

# 1. Public Application Load Balancer
resource "aws_lb" "main" {
  name               = var.alb_name
  internal           = false # Public internet-facing load balancer
  load_balancer_type = "application"
  security_groups    = [var.alb_security_group_id]
  subnets            = var.public_subnet_ids

  tags = merge(var.tags, { Name = var.alb_name })
}

# 2. ALB Target Group
resource "aws_lb_target_group" "main" {
  name        = var.target_group_name
  port        = var.container_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip" # IP target type required for ECS Fargate

  health_check {
    enabled             = true
    path                = "/health" # Health probe endpoint in Node.js app
    port                = "3000"
    protocol            = "HTTP"
    matcher             = "200" # Expects HTTP 200 OK status
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }

  tags = merge(var.tags, { Name = var.target_group_name })
}

# 3. HTTP Port 80 Listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}
