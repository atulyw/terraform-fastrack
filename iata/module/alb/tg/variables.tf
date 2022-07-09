variable "app" {
  type        = string
  description = "applications name"
}

variable "env" {
  type        = string
  description = "env name"
}

variable "vpc_id" {
  type = string
}

variable "priority" {
  type = string
}

variable "path_pattern" {
  type = string
}

variable "tg_port" {
  type = string
}

variable "tg_name" {
  type = string
}

variable "listener_arn" {
  type = string
}