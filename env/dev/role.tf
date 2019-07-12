# # TODO: set lambda app permissions here
# resource "aws_iam_role_policy" "main" {
#   role = "${aws_iam_role.app_role.arn}"
#   name = "${local.ns}"

#   policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Action": [
#         "change:me"
#       ],
#       "Resource": [
#         "*"
#       ]
#     }
#   ]
# }
# EOF
# }

resource "aws_iam_role" "app_role" {
  name = "${local.ns}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "cloudwatch" {
  role = "${aws_iam_role.app_role.id}"
  name = "cw-${local.ns}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "ec2:DescribeNetworkInterfaces",
        "ec2:CreateNetworkInterface",
        "ec2:DeleteNetworkInterface",
        "ec2:DescribeInstances",
        "ec2:AttachNetworkInterface"        
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}
