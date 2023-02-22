resource "aws_alb" "assignment-alb" {
  name               = "${local.env}-${local.application}" # Naming our load balancer
  load_balancer_type = "application"
  subnets            = data.aws_subnets.public.ids
  # Referencing the security group
  security_groups = [aws_security_group.assignment-alb-sg.id]
  idle_timeout    = 300
}


resource "aws_lb_target_group" "assignment-alb-tg" {
  name        = "tg-${local.application}-${local.env}"
  port        = 8080
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.aws_vpc.vpc.id
  health_check {
    matcher  = "200"
    path     = "/"
    timeout  = 45
    interval = 60
  }
  depends_on = [aws_alb.assignment-alb]
}

resource "aws_lb_listener" "alb-listener-redirect" {
  load_balancer_arn = aws_alb.assignment-alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.assignment-alb-tg.arn # Referencing our tagrte group
  }
}
