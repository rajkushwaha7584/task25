variable "aws_region" {
  type = string
}

variable "environment" {
  type = string
}

variable "expected_environment" {
  type = string
}

variable "project_name" {
  type = string
}

variable "owner" {
  type = string
}

variable "allowed_environments" {
  type    = list(string)
  default = ["dev", "prod"]
}

variable "environment_region_map" {
  type = map(string)
  default = {
    dev  = "ap-south-1"
    prod = "us-east-1"
  }
}
