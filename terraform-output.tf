output "cloudfront_url" {
  description = "The CloudFront distribution URL"
  value       = aws_cloudfront_distribution.cloudfront.domain_name
}

output "bucket_name" {
  description = "S3 Bucket Name"
  value       = aws_s3_bucket.s3_bucket.bucket
}

output "cloud_distribution_name" {
  description = "CloudFront Distribution Name"
  value       = aws_cloudfront_distribution.cloudfront.id

}
