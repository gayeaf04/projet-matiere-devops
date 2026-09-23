resource "aws_s3_bucket" "this" {
  count  = var.create_bucket ? 1 : 0
  bucket = var.name

  force_destroy = true

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}