variable "aws_region" {
  type = string

  validation {
    condition     = var.aws_region == "us-east-1"
    error_message = "Prod environment can deploy only in us-east-1."
  }
}

variable "environment" {
  type = string

  validation {
    condition     = var.environment == "prod"
    error_message = "This folder is for prod only. Set environment = \"prod\"."
  }
}

variable "project_name" {
  type = string
}

variable "owner" {
  type = string
}
