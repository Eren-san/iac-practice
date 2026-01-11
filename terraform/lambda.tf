resource "aws_lambda_function" "lambda" {
  function_name = "fargate-metrics"
  filename = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  handler = "lambda.function.lambda_handler"
  runtime = "python3.9"
  role = aws_iam_role.lambda_role.arn
}


data "archive_file" "lambda_zip" {
    type = "zip"
    source_file = "${path.module}/../lambda_function.py" 
    output_path = "${path.module}/../lambda_payload.zip" 
}