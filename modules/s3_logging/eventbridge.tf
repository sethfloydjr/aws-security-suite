resource "aws_cloudwatch_event_rule" "legal_hold" {
  count       = var.enable_sequester ? 1 : 0
  name        = "s3-legal-hold-sequester"
  description = "When legal hold is placed, copy object to sequester bucket"

  event_pattern = jsonencode({
    "source" : ["aws.s3"],
    "detail-type" : ["AWS API Call via CloudTrail"],
    "detail" : {
      "eventSource" : ["s3.amazonaws.com"],
      "eventName" : ["PutObjectLegalHold"]
    }
  })
}

resource "aws_iam_role" "sequester_lambda_role" {
  count = var.enable_sequester ? 1 : 0
  name  = "s3-legal-hold-sequester-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "lambda.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "sequester_lambda_policy" {
  count = var.enable_sequester ? 1 : 0
  name  = "s3-legal-hold-sequester-policy"
  role  = aws_iam_role.sequester_lambda_role[0].id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      # Read from logging bucket(s) in this region
      {
        Effect : "Allow",
        Action : ["s3:GetObject", "s3:GetObjectAttributes", "s3:GetObjectLegalHold", "s3:ListBucket"],
        Resource : [
          aws_s3_bucket.logging.arn,
          "${aws_s3_bucket.logging.arn}/*"
        ]
      },
      # Write to sequester bucket
      {
        Effect : "Allow",
        Action : ["s3:PutObject", "s3:PutObjectTagging", "s3:PutObjectLegalHold"],
        Resource : [
          aws_s3_bucket.sequester[0].arn,
          "${aws_s3_bucket.sequester[0].arn}/*"
        ]
      },
      # Logs
      { Effect : "Allow", Action : ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"], Resource : "*" }
    ]
  })
}



resource "aws_lambda_function" "sequester" {
  count         = var.enable_sequester ? 1 : 0
  function_name = "s3-legal-hold-sequester"
  role          = aws_iam_role.sequester_lambda_role[0].arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.11"
  filename      = data.archive_file.sequester_zip[0].output_path
  timeout       = 60
  memory_size   = 256

  environment { variables = { SEQUESTER_BUCKET = var.sequester_bucket_name } }

  depends_on = [aws_iam_role_policy.sequester_lambda_policy]
}

resource "aws_cloudwatch_event_target" "legal_hold_target" {
  count     = var.enable_sequester ? 1 : 0
  rule      = aws_cloudwatch_event_rule.legal_hold[0].name
  target_id = "lambda"
  arn       = aws_lambda_function.sequester[0].arn
}

resource "aws_lambda_permission" "allow_events" {
  count         = var.enable_sequester ? 1 : 0
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sequester[0].function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.legal_hold[0].arn
}
