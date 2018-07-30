variable "aws_region" {
  default = "us-east-1"
}

variable "wp_image_name" {}

variable "vpc_id" {}

variable "subnet_id" {}

variable "security_group_id" {}

variable "ecs_instance_profile_id" {}

variable "ecs_service_role_name" {}
