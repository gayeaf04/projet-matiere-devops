# --- Outputs S3 ---

output "storage_name" {
  description = "The name of the S3 bucket"
  value       = module.s3.id
}

output "storage_arn" {
  description = "The ARN of the S3 bucket"
  value       = module.s3.arn
}

output "storage_domain_name" {
  description = "The domain name of the S3 bucket"
  value       = module.s3.bucket_domain_name
}

output "storage_hosted_zone_id" {
  description = "The Route 53 Hosted Zone ID of the S3 bucket"
  value       = module.s3.hosted_zone_id
}

# --- Outputs EC2 ---

output "ec2_instance_id" {
  description = "The ID of the EC2 instance"
  value       = module.ec2.id
}

output "ec2_arn" {
  description = "The ARN of the EC2 instance"
  value       = module.ec2.arn
}

output "ec2_instance_state" {
  description = "The state of the EC2 instance"
  value       = module.ec2.instance_state
}

output "ec2_private_dns" {
  description = "The private DNS of the EC2 instance"
  value       = module.ec2.private_dns
}

output "ec2_private_ip" {
  description = "The private IP address of the EC2 instance"
  value       = module.ec2.private_ip
}

output "ec2_public_dns" {
  description = "The public DNS of the EC2 instance"
  value       = module.ec2.public_dns
}

output "ec2_public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = module.ec2.public_ip
}