terraform {
  backend "s3" {
    bucket         = "teraform-test-state-store" 
    key            = "test/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}