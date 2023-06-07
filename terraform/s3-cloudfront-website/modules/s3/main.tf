resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_acl" "this" {
  bucket = aws_s3_bucket.this.id
  acl    = var.bucket_acl
}

resource "aws_s3_bucket_public_access_block" "access_block" {
  bucket = aws_s3_bucket.this.id

  block_public_acls   = false
  block_public_policy = false
}

resource "aws_s3_bucket_website_configuration" "bucket_website" {
  bucket = aws_s3_bucket.this.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.this.id
  # policy = data.aws_iam_policy_document.this.json
  policy = <<POLICY
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Sid":"PublicReadGetObject",
      "Effect":"Allow",
      "Principal": "*",
      "Action":["s3:GetObject", "s3:GetObjectLockConfiguration"],
      "Resource":["arn:aws:s3:::${aws_s3_bucket.this.arn}/*"]
    }
  ]
}
POLICY
}

# 5 - Upload objects
resource "aws_s3_object" "html" { 
  for_each = toset(["index.html", "error.html"])

  bucket        = aws_s3_bucket.this.id
  key           = "html/"      # remote path
  source        = "./website/${each.value}" # where is the file located
  content_type  = "text/html"
  storage_class = "STANDARD"
}