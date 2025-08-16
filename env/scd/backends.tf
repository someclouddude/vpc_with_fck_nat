terraform {
  backend "s3" {
    bucket         = "scd-state"
    key            = "aws-demo/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    use_lockfile   = true
    # OpenTofu 1.10+ supports state locking directly in S3
    # This creates and manages a lock object in the S3 bucket
    # No separate DynamoDB table is needed
  }
}
