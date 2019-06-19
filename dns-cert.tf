# The domain to use for the cert ($environment.$app.$domain)
variable "domain" {}

data "aws_route53_zone" "app" {
  name = "${var.domain}"
}

locals {
  subdomain = "${var.environment}.${var.app}.${var.domain}"
}

resource "aws_route53_record" "dev" {
  zone_id = "${data.aws_route53_zone.app.zone_id}"
  type    = "CNAME"
  name    = "${local.subdomain}"
  records = ["${aws_alb.main.dns_name}"]
  ttl     = "30"
}

resource "aws_acm_certificate" "cert" {
  domain_name       = "${local.subdomain}"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_validation" {
  name    = "${aws_acm_certificate.cert.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.cert.domain_validation_options.0.resource_record_type}"
  zone_id = "${data.aws_route53_zone.app.id}"
  records = ["${aws_acm_certificate.cert.domain_validation_options.0.resource_record_value}"]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = "${aws_acm_certificate.cert.arn}"
  validation_record_fqdns = ["${aws_route53_record.cert_validation.fqdn}"]
}

# The https endpoint that gets provisioned
output "endpoint" {
  value = "https://${local.subdomain}"
}
