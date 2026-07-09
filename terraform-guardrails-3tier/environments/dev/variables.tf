variable "aws_region" {
  type = string

  validation {
    condition     = var.aws_region == "ap-south-1"
    error_message = "Dev environment can deploy only in ap-south-1."
  }
}

variable "environment" {
  type = string

  validation {
    condition     = var.environment == "dev"
    error_message = "This folder is for dev only. Set environment = \"dev\"."
  }
}

variable "project_name" {
  type = string
}

variable "owner" {
  type = string
}
