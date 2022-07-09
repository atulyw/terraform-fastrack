resource "aws_instance" "this" {
  count                  = 2
  ami                    = var.ami
  instance_type          = var.instance_type
  tags                   = var.tags
  vpc_security_group_ids = [aws_security_group.this.id]
  user_data              = <<EOF
#!/bin/bash
sudo yum install httpd -y
echo "Welcome to cloudblitz" >> /var/www/html/index.html 
sudo systemctl start httpd 
EOF  
}

resource "aws_eip" "this" {
  instance = aws_instance.this[0].id
  vpc      = true
  tags     = var.tags
}

resource "aws_security_group" "this" {
  name        = "security-group-tertaform"
  description = "security-group-tertaform"
  vpc_id      = "vpc-0184ae2a565bf5f1b"
  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["172.25.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}




resource "aws_s3_bucket" "d" {
  bucket = "cloudblitz-terraform-fastrack"
  tags = {
    Name = "cloudblitz-terraform-fastrack"
    env  = "dev"
  }
}