output "ecs_service_role_name" {
  value = "${aws_iam_role.ecs_service_role.name}"
}

output "ecs_iam_instance_profile_id" {
  value = "${aws_iam_instance_profile.ecs_instance_profile.id}"
}
