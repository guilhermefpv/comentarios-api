variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "app_name" {
  type = string
  description = "app name"
  default = "comentarios-api"
}

variable "container_port" {
  type = string
  description = "container port"
  default = 8080
}

variable "vpc_cidr" {
  type = string
  description = "VPC cidr"
  default = "10.0.0.0/16"
}

variable "vpc_azs" {
  type = list(string)
  description = "Availability zones for VPC"
  # default = ["eu-east-1a", "eu-east-1b", "eu-east-1c"]
  default = ["us-east-1a", "us-east-1b"]
}

variable "private_subnets" {
  type = list(string)
  description = "Private subnets inside the VPC"
  # default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  default = ["10.0.1.0/24"]
}

variable "public_subnets" {
  type = list(string)
  description = "Public subnets inside the VPC"
  # default = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  default = ["10.0.101.0/24"]
}

variable "health_check_path" {
  default = "/"
}