resource "aws_instance" "this" {
  count         = var.create_instance ? 1 : 0
  ami           = var.ami_id
  instance_type = var.instance_type

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}