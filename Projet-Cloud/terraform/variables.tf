variable "aws_region" {
  type        = string
  description = "Région AWS utilisé"
}

variable "environnement" {
  type        = string
  description = "Environnement du projet"
}

variable "project_name" {
  type        = string
  description = "Nom du projet"
}

variable "ami_id" {
  type        = string
  description = "ID de l'AMI utilisée par l'instance EC2"
  default     = "ami-0c55b159cbfafe1f0"
}

variable "instance_type" {
  type        = string
  description = "Type de l'instance EC2"
  default     = "t2.micro"
}