output "bucket_regional_domain_name" {
  value = aws_s3_bucket.this.bucket_regional_domain_name
}

output "bucket_id" {
  value = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "The ARN of the bucket. Will be of format arn:aws:s3:::bucketname"
  value       = aws_s3_bucket.this.arn
}