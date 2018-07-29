resource "aws_alb_target_group" "test" {
  name     = "my-alb-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"
}

resource "aws_alb" "main" {
  name            = "my-alb-ecs"
  subnets         = ["${var.public_subnets}"]
  security_groups = ["${var.default_security_group_id}"]
}

resource "aws_alb_listener" "front_end" {
  load_balancer_arn = "${aws_alb.main.id}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.test.id}"
    type             = "forward"
  }
}
