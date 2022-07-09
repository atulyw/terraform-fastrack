resource "aws_lb" "application" {
  count              = var.load_balancer_type == "application" ? 1 : 0
  name               = format("%s-%s-alb", var.app, var.env)
  internal           = true
  load_balancer_type = var.load_balancer_type == "application" ? var.load_balancer_type : 0
  security_groups    = var.security_groups
  subnets            = var.internal == "true" ? var.private_subnets : var.public_subnets

  enable_deletion_protection = var.enable_deletion_protection

  # access_logs {
  #   bucket  = aws_s3_bucket.lb_logs.bucket
  #   prefix  = "test-lb"
  #   enabled = true
  # }

  # tags = {
  #   Environment = "production"
  # }
}

resource "aws_lb" "network" {
  count              = var.load_balancer_type == "network" ? 1 : 0
  name               = format("%s-%s-nlb", var.app, var.env)
  internal           = var.internal
  load_balancer_type = var.load_balancer_type == "network" ? var.load_balancer_type : 0
  security_groups    = var.security_groups
  subnets            = var.internal == "true" ? var.private_subnets : var.public_subnets

  enable_deletion_protection = var.enable_deletion_protection

  # access_logs {
  #   bucket  = aws_s3_bucket.lb_logs.bucket
  #   prefix  = "test-lb"
  #   enabled = true
  # }

  # tags = {
  #   Environment = "production"
  # }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = var.load_balancer_type == "application" ? aws_lb.application[0].arn : aws_lb.network[0].arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response content"
      status_code  = "200"
    }
  }
}


module "tg" {
  source       = "./tg"
  env = var.env
  app = var.app
  for_each     = var.app_config
  listener_arn = aws_lb_listener.http.arn
  vpc_id       = var.vpc_id
  priority     = lookup(each.value, "priority", null)
  path_pattern = lookup(each.value, "path_pattern", null)
  tg_port      = lookup(each.value, "port", null)
  tg_name      = each.key
}

#xcode-select --install