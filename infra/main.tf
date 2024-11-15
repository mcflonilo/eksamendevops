provider "aws" {
  region = "eu-west-1"
}

terraform {
  backend "s3" {
    bucket = "pgr301-2024-terraform-state"
    key    = "35/terraform.state"
    region = "eu-west-1"
  }
}

resource "aws_sns_topic" "alarm_topic" {
  name = "cloudwatch-alarm-topic"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.alarm_topic.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

resource "aws_cloudwatch_metric_alarm" "sqs_age_of_oldest_message_alarm" {
  alarm_name          = "Image_Prompt_Queue_35_Alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "ApproximateAgeOfOldestMessage"
  namespace           = "AWS/SQS"
  period              = 300
  statistic           = "Maximum"
  threshold           = 300
  alarm_description   = "Triggered when the age of the oldest message in the SQS queue exceeds 5 minutes."
  actions_enabled     = true
  alarm_actions       = [aws_sns_topic.alarm_topic.arn]

  dimensions = {
    QueueName = "image-prompt-queue-35"
  }
}