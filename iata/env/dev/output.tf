# output "private_subnet_id" {
#   value = module.vpc.private_subnet_id
# }

# output "public_subnet_id" {
#   value = module.vpc.public_subnet_id
# }

# resource "aws_security_group" "allow_tls" {
#   name        = "alb"
#   description = "Allow TLS inbound traffic"
#   vpc_id      = module.vpc.vpc_id

#   ingress {
#     description = "TLS from VPC"
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "allow_tls"
#   }
# }

