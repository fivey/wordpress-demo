terraform {
  backend "s3" {
    bucket  = "fivey-tfstate"
    key     = "wordpress_demo/test/terraform.tfstate"
    region  = "us-east-1"
    encrypt = 1
    acl     = "bucket-owner-full-control"
  }
}

provider "aws" {
  region = "${var.aws_region}"
}

module "iam" {
  source = "../../modules/iam"
}

module "ecs" {
  source            = "../../modules/ecs"
  vpc_id            = "${var.vpc_id}"
  subnet_id         = "${var.subnet_id}"
  security_group_id = "${var.security_group_id}"
}
