resource "aws_security_group" "nsg_lb" {
  name        = "${var.app}-${var.environment}-lb"
  description = "Allow connections from external resources while limiting connections from ${var.app}-${var.environment}-lb to internal resources"
  vpc_id      = "${var.vpc}"
  tags        = "${var.tags}"
}

resource "aws_security_group" "nsg_lambda" {
  name        = "${var.app}-${var.environment}-lambda"
  description = "Limit connections from internal resources while allowing ${var.app}-${var.environment}-lambda to connect to all external resources"
  vpc_id      = "${var.vpc}"
  tags        = "${var.tags}"
}

# Rules for the LB (Targets the lambda SG)

resource "aws_security_group_rule" "nsg_lb_egress_rule" {
  security_group_id        = "${aws_security_group.nsg_lb.id}"
  description              = "Only allow SG ${var.app}-${var.environment}-lb to connect to ${var.app}-${var.environment}-lambda on port ${var.lb_port}"
  type                     = "egress"
  from_port                = "${var.lb_port}"
  to_port                  = "${var.lb_port}"
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.nsg_lambda.id}"
}

# Rules for the lambda (Targets the LB SG)
resource "aws_security_group_rule" "nsg_lambda_ingress_rule" {
  security_group_id        = "${aws_security_group.nsg_lambda.id}"
  description              = "Only allow connections from SG ${var.app}-${var.environment}-lb on port ${var.lb_port}"
  type                     = "ingress"
  from_port                = "${var.lb_port}"
  to_port                  = "${var.lb_port}"
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.nsg_lb.id}"
}

resource "aws_security_group_rule" "nsg_lambda_egress_rule" {
  security_group_id = "${aws_security_group.nsg_lambda.id}"
  description       = "Allows lambda to establish connections to all resources"
  type              = "egress"
  from_port         = "0"
  to_port           = "0"
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}
