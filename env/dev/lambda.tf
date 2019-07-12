data "template_file" "lambda_source" {
  template = <<EOF
exports.handler = (event, context, callback) => {
  console.log(event);
  var response = {
    "statusCode": 200,
    "headers": {
      "Content-Type": "application/json"
    },
    "body": JSON.stringify(event),
    "isBase64Encoded": false
  };
  callback(null, response);
};
EOF
}

resource "aws_lambda_function" "lambda" {
  function_name    = "${local.ns}"
  description      = "${local.ns}"
  role             = "${aws_iam_role.app_role.arn}"
  handler          = "${var.lambda_handler}"
  runtime          = "${var.lambda_runtime}"
  timeout          = "${var.lambda_timeout}"
  filename         = "${data.archive_file.lambda_zip.output_path}"
  source_code_hash = "${data.archive_file.lambda_zip.output_base64sha256}"
  tags             = "${var.tags}"

  vpc_config {
    subnet_ids         = "${local.subnets}"
    security_group_ids = ["${aws_security_group.nsg_lambda.id}"]
  }

  # allow other ways of deploying code after initially provisioning
  lifecycle {
    ignore_changes = ["source_code_hash"]
  }
}

data "archive_file" "lambda_zip" {
  type                    = "zip"
  source_content          = "${data.template_file.lambda_source.rendered}"
  source_content_filename = "index.js"
  output_path             = "lambda-${var.app}.zip"
}

resource "aws_lambda_alias" "lambda" {
  name             = "${local.ns}"
  description      = ""
  function_name    = "${aws_lambda_function.lambda.function_name}"
  function_version = "$LATEST"
}

resource "aws_lambda_permission" "allow_alb_to_invoke_lambda" {
  statement_id  = "AllowExecutionFromALB"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.lambda.function_name}"
  principal     = "elasticloadbalancing.amazonaws.com"
  source_arn    = "${aws_alb_target_group.main.arn}"
}
