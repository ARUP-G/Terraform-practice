provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "teraform_test" {
  instance_type = "t2.micro"
  ami = "ami-09040d770ffe2224f"
  
  tags = {
    name = "terraform_instace_1"
  }

}

# s3 Bucket to store terraform state file
resource "aws_s3_bucket" "s3_bucket" {
  bucket = "teraform-test-state-store"
}

# Creating db_table to store lock file 
resource "aws_dynamodb_table" "terraform_lock" {
  name = "terraform-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}