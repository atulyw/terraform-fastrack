variable "ami" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "tags" {
  type = map(any)
  default = {
    Name     = "terraform"
    env      = "dev"
    accounts = "cbz"
  }
}
variable "name" {
  type    = list(any)
  default = ["mumbai", "pune"]

}

#-target=resource