terraform {
  backend "s3" {
    bucket         = "tf-backend-bucket-73"
    key            = "global/terraform.tfstate"
    region         = "us-east-1"  # Replace with your region
    dynamodb_table = "tf-state-lock"  # For state locking and consistency checking
    encrypt        = true           # Encrypt the state file at rest in S3
  }
}



provider "aws" {
  region = "us-east-1" # Don't change the region
}
