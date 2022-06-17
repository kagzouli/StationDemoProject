resource "aws_s3_bucket" "lambda_code_bucket" {
  bucket = "station-lambda-code-bucket"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
      }
    }
  }

# NB: pas de lifecycle rule pour ne jamais supprimer le code source des lambdas
  
   tags = {
      Name = "station-lambda-code-bucket"
      Application= var.application
   }


}

resource "aws_s3_bucket_public_access_block" "deny_all_public" {
  bucket = aws_s3_bucket.lambda_code_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

