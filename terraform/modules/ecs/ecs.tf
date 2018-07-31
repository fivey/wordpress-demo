# Verify AMI ID before running this

resource "aws_launch_configuration" "ecs_launch_configuration" {
  name                 = "ecs-launch-configuration"
  image_id             = "ami-aff65ad2"
  instance_type        = "t2.micro"
  iam_instance_profile = "${var.ecs_iam_instance_profile_id}"

  root_block_device {
    volume_type           = "standard"
    volume_size           = 100
    delete_on_termination = true
  }

  lifecycle {
    create_before_destroy = true
  }

  associate_public_ip_address = "false"
  key_name                    = "test"

  user_data = "#!/bin/bash\necho ECS_CLUSTER=${aws_ecs_cluster.ecs_cluster.name} > /etc/ecs/ecs.config"
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = "wp-ecs-cluster"
}

# Wordpress
data "aws_ecs_task_definition" "wp_ecs_task_definition" {
  task_definition = "${aws_ecs_task_definition.wp_ecs_task_definition.family}"
  depends_on      = ["aws_ecs_task_definition.wp_ecs_task_definition"]
}

resource "aws_ecs_task_definition" "wp_ecs_task_definition" {
  family                = "wp-demo-family"
  container_definitions = "${data.template_file.task_webapp.rendered}"
}

data "template_file" "task_webapp" {
  template = "${file("${path.module}/task_definition.json")}"

  vars {
    webapp_docker_image = "${var.wp_image_name}:latest"
  }
}

resource "aws_ecs_service" "wp_ecs_service" {
  name            = "wp-service"
  cluster         = "${aws_ecs_cluster.ecs_cluster.id}"
  task_definition = "${aws_ecs_task_definition.wp_ecs_task_definition.family}:${max("${aws_ecs_task_definition.wp_ecs_task_definition.revision}", "${data.aws_ecs_task_definition.wp_ecs_task_definition.revision}")}"
  desired_count   = 1
  iam_role        = "${var.ecs_service_role_name}"

  load_balancer {
    target_group_arn = "${aws_alb_target_group.alb_target_group.id}"
    container_name   = "nginx"
    container_port   = "80"
  }

  depends_on = [
    "aws_alb_listener.alb_listener",
  ]
}

# MySQL
data "aws_ecs_task_definition" "mysql_ecs_task_definition" {
  task_definition = "${aws_ecs_task_definition.mysql_ecs_task_definition.family}"
  depends_on      = ["aws_ecs_task_definition.mysql_ecs_task_definition"]
}

resource "aws_ecs_task_definition" "mysql_ecs_task_definition" {
  family                = "mysql-demo-family"
  container_definitions = "${data.template_file.task_mysql.rendered}"
}

data "template_file" "task_mysql" {
  template = "${file("${path.module}/task_definition.json")}"

  vars {
    webapp_docker_image = "${var.mysql_image_name}:5.7"
  }
}

resource "aws_ecs_service" "mysql_ecs_service" {
  name            = "mysql-service"
  cluster         = "${aws_ecs_cluster.ecs_cluster.id}"
  task_definition = "${aws_ecs_task_definition.mysql_ecs_task_definition.family}:${max("${aws_ecs_task_definition.mysql_ecs_task_definition.revision}", "${data.aws_ecs_task_definition.mysql_ecs_task_definition.revision}")}"
  desired_count   = 1
  iam_role        = "${var.ecs_service_role_name}"
}
