output "website_bucket_endpoint" {
  value       = aws_s3_bucket.website.website_endpoint
  description = "The endpoint URL of the website bucket"
}

output "redirect_bucket_endpoint" {
  value       = aws_s3_bucket.redirect.website_endpoint
  description = "The endpoint URL of the redirect bucket"
}