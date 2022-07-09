variable "app" {
  type        = string
  description = "applications name"
}

variable "env" {
  type        = string
  description = "env name"
}

variable "load_balancer_type" {
  type    = string
  default = "application"
}
variable "internal" {
  type    = bool
  default = true
}

variable "security_groups" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "enable_deletion_protection" {
  type    = bool
  default = false
}

variable "app_config" {
  type = map(any)
}

variable "vpc_id" {
  type = string
}