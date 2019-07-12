terraform {
  required_version = ">= 0.11.0"
}

# The AWS region to use for the dev environment's infrastructure.
variable "region" {
  default = "us-east-1"
}

# The AWS Profile to use
variable "aws_profile" {}

provider "aws" {
  version = ">= 1.53.0"
  region  = "${var.region}"
  profile = "${var.aws_profile}"
}

data "aws_caller_identity" "current" {}

locals {
  ns      = "${var.app}-${var.environment}"
  subnets = "${split(",", var.internal == true ? var.private_subnets : var.public_subnets)}"
}
