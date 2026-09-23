variable "name" {
  type        = string
  description = "Nom du module"
}

variable "ami_id" {
  description = "L'ID de l'AMI pour l'instance EC2"
  type        = string
}

variable "instance_type" {
  description = "Description de l'instance"
  type        = string
}

variable "create_instance" {
  type        = bool
  description = "Indique si l'instance EC2 doit être créée"
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "Tags appliqués à l'instance EC2"
  default     = {}
}