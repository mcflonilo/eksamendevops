resource "aws_lambda_function" "bedrock_image_generator" {
  function_name = var.lambda_function_name
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "lambda_sqs.lambda_handler"
  runtime       = "python3.9"

  filename         = "lambda_function.zip"
  source_code_hash = filebase64sha256("lambda_function.zip")

  environment {
    variables = {
      BUCKET_NAME = data.aws_s3_bucket.image_bucket_name.bucket
    }
  }

  timeout     = 60
  memory_size = 512
}
