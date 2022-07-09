resource "aws_lb_listener_rule" "static" {
  listener_arn = var.listener_arn
  priority     = var.priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }

  condition {
    path_pattern {
      values = [var.path_pattern]
    }
  }
}

resource "aws_lb_target_group" "this" {
  name     = var.tg_name
  port     = var.tg_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}
