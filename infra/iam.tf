resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda-exec-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}


resource "aws_iam_role_policy" "lambda_sqs_policy" {
  name   = "lambda-sqs-policy"
  role   = aws_iam_role.lambda_exec_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["s3:GetObject", "s3:ListBucket"]
        Effect   = "Allow"
        Resource = [
          "arn:aws:s3:::your-s3-bucket-name/*",
          "arn:aws:s3:::your-s3-bucket-name"
        ]
      },
      {
        Action   = "sqs:ReceiveMessage"
        Effect   = "Allow"
        Resource = "arn:aws:sqs:eu-west-1:244530008913:image-prompt-queue"
      },
      {
        Action   = "sqs:DeleteMessage"
        Effect   = "Allow"
        Resource = "arn:aws:sqs:eu-west-1:244530008913:image-prompt-queue"
      },
      {
        Action   = "sqs:GetQueueAttributes"
        Effect   = "Allow"
        Resource = "arn:aws:sqs:eu-west-1:244530008913:image-prompt-queue"
      }
    ]
  })
}
