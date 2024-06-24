# Terraform Configuration for AWS Infrastructure (Backend & tf.lock logic)
This module contains Terraform configuration files to deploy a simple AWS infrastructure that includes an EC2 instance, an S3 bucket for storing the Terraform state file, and a DynamoDB table for state locking.

## File Structure
- **main.tf**: Contains the main Terraform configuration for the AWS provider, resources such as an EC2 instance, S3 bucket, and DynamoDB table.
- **backend.tf**: Configures the backend to store the Terraform state in the S3 bucket and use DynamoDB for state locking.

## Configuration Details
### main.tf
This file includes the following configurations:

### AWS Provider
Specifies the AWS region to be used.

``` sh
provider "aws" {
  region = "us-east-2"
} 
```

### EC2 Instance
Defines an EC2 instance with the following specifications:

- Instance type: `t2.micro`
- AMI: `ami-09040d770ffe2224f`
- Tags: name = `"terraform_instance_1"`


``` sh
resource "aws_instance" "terraform_test" {
  instance_type = "t2.micro"
  ami = "ami-09040d770ffe2224f" 

  tags = {
    name = "terraform_instance_1"
  }
}
```
### S3 Bucket
Creates an S3 bucket to store the Terraform state file.


``` sh
resource "aws_s3_bucket" "s3_bucket" {
  bucket = "terraform-test-state-store"
}
```

### DynamoDB Table
Creates a DynamoDB table to store the lock file for state locking.

```sh
resource "aws_dynamodb_table" "terraform_lock" {
  name         = "terraform-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
```
## backend.tf
This file configures the backend to store the Terraform state file in the S3 bucket and to use the DynamoDB table for state locking. This ensures that the state file is stored securely and that only one process can modify the state at a time.

```sh
terraform {
  backend "s3" {
    bucket         = "terraform-test-state-store" 
    key            = "test/terraform.tfstate"
    region         = "us-east-2"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}

```
## Usage
1. Initialize Terraform:

```sh
terraform init
```
2. Validate the configuration:
```sh

terraform plan
```
3. Apply the configuration:

```sh

terraform apply
```
This will create the defined AWS resources including the EC2 instance, S3 bucket, and DynamoDB table.

4. Destroy the infrastructure:

```sh
terraform destroy
```
This will remove all the resources defined in the configuration.

## Notes
- Ensure you have the AWS credentials configured in your environment or through the AWS CLI.
- The S3 bucket name must be unique across all AWS accounts.
- Modify the `ami` value in `aws_instance` to use an AMI available in your AWS region.
