output "id" {
  description = "The name of the bucket"
  value       = try(aws_s3_bucket.this[0].id, null)
}

output "arn" {
  description = "The ARN of the bucket. Will be of format arn:aws:s3:::bucketname"
  value       = try(aws_s3_bucket.this[0].arn, null)
}

output "bucket_domain_name" {
  description = "The bucket domain name. Will be of format bucketname.s3.amazonaws.com"
  value       = try(aws_s3_bucket.this[0].bucket_domain_name, null)
}

output "hosted_zone_id" {
  description = "The Route 53 Hosted Zone ID for this bucket's region"
  value       = try(aws_s3_bucket.this[0].hosted_zone_id, null)
}