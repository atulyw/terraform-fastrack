resource "aws_s3_bucket" "this" {
 bucket = local.bucket_name
 #tags = var.tags
}

locals {
  bucket_name = var.load_balancer_type == "application" ? format("%s-%s-application", var.app, var.env) : format("%s-%s-network", var.app, var.env)
}

resource "aws_s3_bucket_policy" "log_access" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.this.json
}



data "aws_iam_policy_document" "this" {
  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:s3:::${aws_s3_bucket.this.id}/${var.app}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"]
    actions   = ["s3:PutObject"]

    principals {
      type        = "AWS"
      identifiers = [data.aws_elb_service_account.main.arn]
    }
  }
}

data "aws_caller_identity" "current" {}
data "aws_elb_service_account" "main" {}
