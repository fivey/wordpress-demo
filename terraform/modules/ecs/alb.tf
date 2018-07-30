resource "aws_alb_target_group" "alb_target_group" {
  name     = "wp-alb-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"
}

resource "aws_alb" "alb" {
  name            = "wp-alb-ecs"
  subnets         = ["${var.subnet_id}"]
  security_groups = ["${var.security_group_id}"]
}

resource "aws_alb_listener" "alb_listener" {
  load_balancer_arn = "${aws_alb.alb.id}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.alb_target_group.id}"
    type             = "forward"
  }
}
