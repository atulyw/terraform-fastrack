# resource "aws_iam_user" "lb" {
#   count = length(var.users)
#   name  = var.users[count.index]
# #  name  = "loadbalancer-${count.index + 1}"
#   path  = "/system/"
# }


# variable "users" {
#   type = list
#   default = ["dev", "test", "uat", "prod", "qa"]
# }


resource "aws_instance" "dev" {
  count         = var.env == "dev" ? 1 : 0
  ami           = "ami-0cff7528ff583bf9a"
  instance_type = "t2.micro"

  dynamic "ebs_block_device" {
    for_each = var.ebs_block_device
    content {
      volume_size = ebs_block_device.key
      device_name = ebs_block_device.value["device_name"]
      volume_type = ebs_block_device.value["volume_type"]
    }
  }
}

variable "ebs_block_device" {
  type = map(any)
  default = {
    "50" = {
      device_name = "/dev/xvdb"
      volume_type = "gp2"

    }
    "70" = {
      device_name = "/dev/xvdc"
      volume_type = "gp2"
    }
    "100" = {
      device_name = "/dev/xvdd"
      volume_type = "gp2"
    }
  }

}

resource "aws_s3_bucket" "this" {
  bucket = "${var.namespace}-${var.env}-bucket"
}


variable "env" {
  type    = string
  default = "dev"
}

variable "namespace" {
  type    = string
  default = "iata"
}

# resource "aws_instance" "prod" {
#     count = var.env == "dev" ? 0 : 1
#     ami = "ami-0cff7528ff583bf9a"
#     name = local.cluster_name
#     instance_type = "t2.medium" 
# }

variable "tags" {
  type = map(any)
  default = {
    billing_unit = "greamio tech pvt ltd"
    owner_name   = "cloudblitz"
    application  = "iata"
  }
}

variable "apps" {
  type = map(any)
  default = {
    env      = "dev"
    location = "pune"
  }
}

locals {
  cluster_name = "rama"
}


resource "aws_security_group" "allow_tls" {
  name   = format("%s-%s-sg", var.env, var.namespace)
  vpc_id = "vpc-0184ae2a565bf5f1b"

  dynamic "ingress" {
    for_each = var.ports
    iterator = ports
    content {
      description = "TLS from VPC"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({
    Name = format("%s-%s-sg", var.env, var.namespace),
  }, var.tags)
}

variable "ports" {
  type    = list(any)
  default = ["80", "8080", "8090", "443", "22"]
}