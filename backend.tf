terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
  
  backend "s3" {
    # These values will be set during terraform init
    # terraform init -backend-config="bucket=YOUR_BUCKET_NAME" \
    #               -backend-config="key=demo/terraform.tfstate" \
    #               -backend-config="region=ap-south-1" \
    #               -backend-config="dynamodb_table=YOUR_TABLE_NAME"
  }
}

