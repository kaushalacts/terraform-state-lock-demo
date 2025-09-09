output "state_bucket_name" {
  value       = aws_s3_bucket.terraform_state.id
  description = "The name of the S3 bucket for storing Terraform state"
}

output "dynamodb_table_name" {
  value       = aws_dynamodb_table.terraform_locks.name
  description = "The name of the DynamoDB table for state locking"
}

output "region" {
  value       = var.aws_region
  description = "The AWS region where resources are created"
}

output "backend_config_example" {
  value = <<-EOT
    To initialize your Terraform backend, run:
    
    terraform init \
      -backend-config="bucket=${aws_s3_bucket.terraform_state.id}" \
      -backend-config="key=demo/terraform.tfstate" \
      -backend-config="region=${var.aws_region}" \
      -backend-config="dynamodb_table=${aws_dynamodb_table.terraform_locks.name}"
  EOT
  description = "Example backend configuration command"
}
