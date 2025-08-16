# Input variables for the module
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.1.0.0/16"
}

variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "availability_zones" {
  description = "List of availability zones to use"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "binky2"
}

variable "environment" {
  description = "Environment (e.g. dev, prod)"
  type        = string
  default     = "home"
}

variable "nat-instance_type" {
  description = "Instance type for EC2 instances"
  type        = string
  default     = "t4g.small"
}

variable "test-instance_type" {
  description = "Instance type for EC2 instances"
  type        = string
  default     = "t4g.micro"
}