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
        Resource = "arn:aws:sqs:eu-west-1:244530008913:image-prompt-queue-35"
      },
      {
        Action   = "sqs:DeleteMessage"
        Effect   = "Allow"
        Resource = "arn:aws:sqs:eu-west-1:244530008913:image-prompt-queue-35"
      },
      {
        Action   = "sqs:GetQueueAttributes"
        Effect   = "Allow"
        Resource = "arn:aws:sqs:eu-west-1:244530008913:image-prompt-queue-35"
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_s3_policy" {
  name   = "lambda_s3_policy"
  role   = aws_iam_role.lambda_exec_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "s3:PutObject"
        Resource = "arn:aws:s3:::pgr301-couch-explorers/*"
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_bedrock_policy" {
  name   = "lambda_bedrock_policy"
  role   = aws_iam_role.lambda_exec_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "bedrock:InvokeModel"
        Resource = "arn:aws:bedrock:us-east-1::foundation-model/amazon.titan-image-generator-v1"
      }
    ]
  })
}