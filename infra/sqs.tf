resource "aws_sqs_queue" "image_prompt_queue" {
  name = "image-prompt-queue"
  visibility_timeout_seconds = 60
}

resource "aws_lambda_event_source_mapping" "sqs_lambda_trigger" {
  event_source_arn = aws_sqs_queue.image_prompt_queue.arn
  function_name    = aws_lambda_function.bedrock_image_generator.arn
  enabled          = true
  batch_size       = 10
}
