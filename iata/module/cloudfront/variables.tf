variable "app" {
  type        = string
  description = "applications name"
}

variable "env" {
  type        = string
  description = "env name"
}

variable "mircofrontend" {
  type = list(any)
}

variable "acl" {
  type    = string
  default = "public-read"
}

variable "versioning" {
  type    = bool
  default = false
}

variable "tags" {
  type    = map(any)
  default = {}
}