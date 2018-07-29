# Verify AMI ID before running this

#
# need to add security group config
# so that we can ssh into an ecs host from bastion box
#

resource "aws_launch_configuration" "ecs-launch-configuration" {
  name                 = "ecs-launch-configuration"
  image_id             = "ami-aff65ad2"
  instance_type        = "t2.medium"
  iam_instance_profile = "${aws_iam_instance_profile.ecs-instance-profile.id}"

  root_block_device {
    volume_type           = "standard"
    volume_size           = 100
    delete_on_termination = true
  }

  lifecycle {
    create_before_destroy = true
  }

  associate_public_ip_address = "false"
  key_name                    = "testone"

  user_data = "#!/bin/bash\necho ECS_CLUSTER=${aws_ecs_cluster.default.name} > /etc/ecs/ecs.config"
}

resource "aws_ecs_cluster" "ecs-cluster" {
  name = "myecscluster"
}

data "aws_ecs_task_definition" "test" {
  task_definition = "${aws_ecs_task_definition.test.family}"
  depends_on      = ["aws_ecs_task_definition.test"]
}

resource "aws_ecs_task_definition" "test" {
  family = "test-family"

  container_definitions = "${data.template_file.task_webapp.rendered}"
}

data "template_file" "task_webapp" {
  template = "${file("task-definitions/ecs_task_webapp.tpl")}"

  vars {
    webapp_docker_image = "${var.docker_image_name}:latest"
  }
}

resource "aws_ecs_service" "test-ecs-service" {
  name            = "test-vz-service"
  cluster         = "${aws_ecs_cluster.test-ecs-cluster.id}"
  task_definition = "${aws_ecs_task_definition.test.family}:${max("${aws_ecs_task_definition.test.revision}", "${data.aws_ecs_task_definition.test.revision}")}"
  desired_count   = 1
  iam_role        = "${aws_iam_role.ecs-service-role.name}"

  load_balancer {
    target_group_arn = "${aws_alb_target_group.test.id}"
    container_name   = "nginx"
    container_port   = "80"
  }

  depends_on = [
    "aws_alb_listener.front_end",
  ]
}
