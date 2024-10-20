
# Backend
terraform {
  backend "s3" {
    bucket         = "terraform-huytran-state-bucket"
    key            = "./terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform_state_table"
    encrypt        = true
  }   
}

# IAM User for Terraform
resource "aws_iam_user" "terraform_user" {
  name = var.terraform_iam_user_name
}

# Attach AdministratorAccess policy to the IAM user
resource "aws_iam_user_policy_attachment" "admin_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  user       = aws_iam_user.terraform_user.id
}

# S3 Bucket for Terraform state
resource "aws_s3_bucket" "terraform_state_bucket" {
  bucket = var.state_bucket_name

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name    = var.state_bucket_name
  }
}

# Enable versioning for the S3 bucket
resource "aws_s3_bucket_versioning" "versioning_enabled" {
  bucket = aws_s3_bucket.terraform_state_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# S3 Bucket Policy
resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket = aws_s3_bucket.terraform_state_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "s3:ListBucket",
        Resource = aws_s3_bucket.terraform_state_bucket.arn,
        Principal = {
          AWS = aws_iam_user.terraform_user.arn
        }
      },
      {
        Effect   = "Allow",
        Action   = ["s3:GetObject", "s3:PutObject"],
        Resource = "${aws_s3_bucket.terraform_state_bucket.arn}/*",
        Principal = {
          AWS = aws_iam_user.terraform_user.arn
        }
      }
    ]
  })
}

# DynamoDB Table for state locking
resource "aws_dynamodb_table" "state_lock_table" {
  name         = var.state_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name    = var.state_table_name
  }
}