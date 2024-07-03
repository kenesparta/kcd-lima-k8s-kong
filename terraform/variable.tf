variable "domain_name" {
  type = string
}

variable "project_name" {
  type = string
  description = "(string) global project name"
}

variable "region" {
  type = string
  default = "us-central1"
}
