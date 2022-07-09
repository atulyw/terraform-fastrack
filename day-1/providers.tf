terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "shubham-dev"
}


resource "aws_s3_bucket" "this" {
  bucket = "cloudblitz-terraform-fastrack"
  tags = {
    Name = "cloudblitz-terraform-fastrack"
    env  = "dev"
  }
}

output "bucket_arn" {
  value = aws_s3_bucket.this.arn
}

output "bucket_zd" {
  value = aws_s3_bucket.this.hosted_zone_id
}