variable "wp_image_name" {
  default = "wordpress"
}

variable "mysql_image_name" {
  default = "mysql"
}

variable "vpc_id" {}

variable "subnet_id" {}

variable "security_group_id" {}

variable "ecs_iam_instance_profile_id" {}

variable "ecs_service_role_name" {}
