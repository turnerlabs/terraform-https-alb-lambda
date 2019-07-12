# create ci/cd user with access keys (for build system)
resource "aws_iam_user" "cicd" {
  name = "srv_${local.ns}_cicd"
}

resource "aws_iam_access_key" "key_a" {
  user = "${aws_iam_user.cicd.name}"
}

# grant required permissions to deploy
data "aws_iam_policy_document" "cicd_policy" {
  statement {
    sid = "lambda"

    actions = [
      "lambda:UpdateFunctionCode",
    ]

    resources = [
      "${aws_lambda_function.lambda.arn}",
    ]
  }
}

resource "aws_iam_user_policy" "cicd_user_policy" {
  name   = "${local.ns}_cicd"
  user   = "${aws_iam_user.cicd.name}"
  policy = "${data.aws_iam_policy_document.cicd_policy.json}"
}
