module "s3" {
  source = "./modules/s3"

  name = local.resource_prefix
  tags = local.common_tags
}

module "ec2" {
  source = "./modules/ec2"

  name          = local.resource_prefix
  ami_id        = var.ami_id
  instance_type = var.instance_type
  tags          = local.common_tags
}