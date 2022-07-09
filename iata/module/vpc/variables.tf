variable "app" {
  type        = string
  description = "applications name"
}

variable "env" {
  type        = string
  description = "env name"
}

variable "vpc_cidr_block" {
  type = string
}

variable "enable" {
  type    = string
  default = true
}

variable "instance_tenancy" {
  type    = string
  default = "default"
}

variable "enable_dns_support" {
  type    = bool
  default = true
}

variable "enable_dns_hostnames" {
  type    = bool
  default = false
}

variable "private_cidr_block" {
  type = list(string)
}

variable "public_cidr_block" {
  type = list(string)
}

variable "database_cidr_block" {
  type = list(string)
}

variable "availability_zone" {
  type = list(string)
}

variable "tags" {
  type    = map(string)
  default = {}
}