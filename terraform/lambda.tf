resource "aws_lambda_function" "lambda" {
  function_name = "fargate-metrics"
  filename = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  handler = "lambda_function.lambda_handler"
  runtime = "python3.9"
  role = aws_iam_role.lambda_role.arn
}


data "archive_file" "lambda_zip" {
    type = "zip"
    source_file = "${path.module}/../lambda_function.py" 
    output_path = "${path.module}/../lambda_payload.zip" 
}

resource "aws_cloudwatch_event_rule" "every_hour" {
  name = "fargate-metrics-hourly"
  schedule_expression = "rate(1 hour)"
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule = aws_cloudwatch_event_rule.every_hour.name
  target_id = "fargate_metrics_lambda"
  arn = aws_lambda_function.lambda.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.every_hour.arn
}

resource "aws_s3_bucket" "lambda_reports" {
  bucket = "s3-b-t-s2"
}