variable "name" {
  type        = string
  description = "Nom du module"
}

variable "create_bucket" {
  type        = bool
  description = "Indique si le bucket S3 doit être créé"
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "Tags appliqués au bucket S3"
  default     = {}
}