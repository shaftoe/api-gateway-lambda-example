resource "aws_lambda_function" "api" {
  filename         = "lambda.zip"
  function_name    = replace(var.domain_name, ".", "-")
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = "lambda.lambda_handler"
  source_code_hash = filebase64sha256("lambda.zip")
  runtime          = "python3.6"

  environment {
    variables = {
      PUSHOVER_TOKEN   = var.pushover_token
      PUSHOVER_USERKEY = var.pushover_userkey
    }
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "${replace(var.domain_name, ".", "-")}-lambda"

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

data "aws_iam_policy_document" "policy_for_lambda" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [aws_cloudwatch_log_group.lambda-api.arn]
  }
}

resource "aws_iam_role_policy" "policy_for_lambda" {
  name = "${replace(var.domain_name, ".", "-")}-lambda"
  role = aws_iam_role.iam_for_lambda.id
  policy = data.aws_iam_policy_document.policy_for_lambda.json
}

resource "aws_cloudwatch_log_group" "lambda-api" {
  name = "/aws/lambda/${replace(var.domain_name, ".", "-")}"
  retention_in_days = var.log_retention_in_days
}
