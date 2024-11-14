# main.tf

provider "aws" {
  region = "eu-west-1"
}

terraform {
  backend "s3" {
    bucket = "pgr301-2024-terraform-state"  # The name of your Terraform state bucket
    key    = "35/terraform.state"   # Define a path for your state file within the bucket
    region = "eu-west-1"                   # Correct region of the S3 bucket
  }
}

