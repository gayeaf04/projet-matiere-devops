locals {
  resource_prefix = "${var.project_name}-${var.environnement}"

  common_tags = {
    Environment = var.environnement
    Project     = var.project_name
  }
}