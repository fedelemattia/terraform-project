resource "aws_lb" "this" {
  name               = "mattiafedele-internal-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = [var.subnet_id]

  enable_cross_zone_load_balancing = false

  tags = {
    Name        = "mattiafedele-internal-nlb"
  }
}

##### Listeners #####

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

##### TCP HealthCheck #####

resource "aws_lb_target_group" "this" {
  name        = "webserver-nlb-tg"
  port        = 4200
  protocol    = "TCP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  deregistration_delay = 120 # default 300

  health_check {
    port                = "4200"
    interval            = "30"
    protocol            = "TCP"
    healthy_threshold   = "2"
    unhealthy_threshold = "2"
    # timeout             = "10" # default
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name        = "web_server-nlb-tg"
  }
}

resource "aws_lb_target_group_attachment" "this" {
  target_group_arn = aws_lb_target_group.this.arn
  target_id        = aws_instance.web.id
  port             = 4200
}