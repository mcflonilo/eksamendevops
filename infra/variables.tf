variable "state_bucket_name" {
  description = "The S3 bucket to store Terraform state"
  default     = "pgr301-2024-terraform-state"  # Replace with the state bucket name
}

variable "image_bucket_name" {
  description = "The S3 bucket for Lambda to store generated images"
  default     = "pgr301-couch-explorers"  # Replace with the image storage bucket name
}
variable "lambda_function_name" {
  description = "The name of the Lambda function"
  default     = "35_generate_image"
  type        = string
}
variable "alert_email" {
  description = "The email address to send CloudWatch alarms to"
  type        = string
}