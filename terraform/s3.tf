locals {
    s3_bucket_origin    = "s3origin"
}

resource "aws_s3_bucket" "prod_website" {
    bucket  = var.primary_domain
}

resource "aws_s3_bucket_acl" "prod_website" {
    bucket  = aws_s3_bucket.prod_website.id
    acl     = "public-read"
}

resource "aws_s3_bucket_policy" "prod_website" {
    bucket  = aws_s3_bucket.prod_website.id
    policy  = data.aws_iam_policy_document.public_website.json
}

data "aws_iam_policy_document" "public_website" {
    statement {
        principals {
            type        = "*"
            identifiers = ["*"]
        }

        actions = [
            "s3:GetObject"
        ]

        resources = [
            "${resource.aws_s3_bucket.prod_website.arn}/*"
        ]
    }
}

resource "aws_s3_bucket_website_configuration" "prod_website" {
    bucket  = aws_s3_bucket.prod_website.id

    index_document {
        suffix = "index.html"
    }
}