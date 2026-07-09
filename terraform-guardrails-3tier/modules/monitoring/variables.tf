variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "instance_ids" {
  type = list(string)
}

variable "instance_names" {
  type = list(string)

  validation {
    condition     = length(var.instance_names) == length(var.instance_ids)
    error_message = "instance_names must have the same number of items as instance_ids."
  }
}

variable "cpu_threshold" {
  type    = number
  default = 80
}

variable "alarm_actions" {
  type    = list(string)
  default = []
}
