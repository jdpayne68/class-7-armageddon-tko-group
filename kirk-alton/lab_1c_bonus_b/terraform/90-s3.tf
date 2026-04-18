# Terraform Managed S3 Bucket - Terraform Bucket
resource "aws_s3_bucket" "terraform_bucket" {
  bucket = "terraform-managed-bucket-${local.region}-${local.bucket_suffix}"

  force_destroy = true

  tags = {
    Name        = "terraform-managed-bucket"
    Component   = "storage"
    DataClass   = "internal"
    Environment = "${local.environment}"
  }
}
# Server Side Encryption - Terraform Bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_bucket" {
  bucket = aws_s3_bucket.terraform_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}