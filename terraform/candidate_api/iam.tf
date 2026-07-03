data "aws_iam_policy_document" "lambda_assume_role" {

  statement {

    effect = "Allow"

    actions = [
      "sts:AssumeRole"
    ]

    principals {

      type = "Service"

      identifiers = [
        "lambda.amazonaws.com"
      ]
    }
  }
}

data "aws_iam_policy_document" "lambda_policy" {

  statement {

    sid = "CloudWatchLogs"

    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = ["*"]
  }

  statement {

    sid = "S3Access"

    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]

    resources = [
      "${module.s3["resume"].bucket_arn}/*"
    ]
  }

  statement {

    sid = "DynamoDBAccess"

    effect = "Allow"

    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem"
    ]

    resources = [
      module.dynamodb["candidates"].table_arn
    ]
  }
}

resource "aws_iam_role" "lambda" {

  name = "candidate-api-lambda-role"

  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json

  tags = merge(local.default_tags, var.iam_tags)
}


resource "aws_iam_policy" "lambda" {

  name = "candidate-api-lambda-policy"

  policy = data.aws_iam_policy_document.lambda_policy.json

  tags = merge(local.default_tags, var.iam_tags)
}

resource "aws_iam_role_policy_attachment" "lambda" {

  role = aws_iam_role.lambda.name

  policy_arn = aws_iam_policy.lambda.arn
}