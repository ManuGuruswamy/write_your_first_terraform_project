
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# CREATE AN S3 BUCKET AND DYNAMODB TABLE TO USE AS A TERRAFORM BACKEND
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

terraform {
  required_version = ">= 0.12"
}

# AWS PROVIDER
provider "aws" {}


# Fetch AWS Account ID
data "aws_caller_identity" "current" {}


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# CREATE THE S3 BUCKET
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

resource "aws_s3_bucket" "terraform_state" {
  bucket = "my-sample-s3-terraform-states-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name = "Terraform State Bucket"
  }
}

# Enable versioning

resource "aws_s3_bucket_versioning" "terraform_state_versioning" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}


# Enable encryption on the S3 bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_encryption" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# CREATE THE DYNAMODB TABLE
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

resource "aws_dynamodb_table" "terraform_lock" {
  name         = "terraform-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

<<<<<<< HEAD

# ------------------------------------------------------------------------------
# TERRAFORM BACKEND ENABLING
# ------------------------------------------------------------------------------

terraform {
  backend "s3" {
    bucket         = "${local.account_id}-terraform-states"
    key            = "terraform/state.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
=======
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# CONFIGURE TERRAFORM BACKEND
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

terraform {
  backend "s3" {
    bucket       = "my-sample-s3-terraform-states"
    key          = "terraform/state.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
>>>>>>> 197cd48 (Updated terraform backend configuration)
  }
}
