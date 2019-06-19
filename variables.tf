/*
 * variables.tf
 * Common variables to use in various Terraform files (*.tf)
 */

# Tags for the infrastructure
variable "tags" {
  type = "map"
}

# The application's name
variable "app" {}

# The environment that is being built
variable "environment" {}

# The port the load balancer will listen on
variable "lb_port" {
  default = "80"
}

# The load balancer protocol
variable "lb_protocol" {
  default = "HTTP"
}

# Network configuration

# The VPC to use for the Fargate cluster
variable "vpc" {}

# The private subnets, minimum of 2, that are a part of the VPC(s)
variable "private_subnets" {}

# The public subnets, minimum of 2, that are a part of the VPC(s)
variable "public_subnets" {}

# The lambda runtime
variable "lambda_runtime" {
  default = "nodejs10.x"
}

# The lambda handler
variable "lambda_handler" {
  default = "index.handler"
}

# The lambda timeout
variable "lambda_timeout" {
  default = "60"
}

# The SAML role to use for adding users to the ECR policy
variable "saml_role" {}
