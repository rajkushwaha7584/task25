variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "ami" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "key_name" {
  type = string
}

variable "public_subnet_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "master_sg" {
  type = string
}

variable "worker_sg" {
  type = string
}

variable "monitoring_sg" {
  type = string
}

variable "worker_user_data" {
  type    = string
  default = null
}
