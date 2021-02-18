provider "aws" {
  region = var.region
}

provider "cloudflare" {}

# Look up the Cloudflare zone that manages the domain
data "cloudflare_zones" "selected" {
  filter {
    name = var.domain
  }
}

# This S3 bucket will host the website files
resource "aws_s3_bucket" "website" {
  bucket        = var.fqdn
  force_destroy = var.force_destroy

  website {
    index_document = var.index_document
    error_document = var.error_document
  }
}

# This policy will allow an IAM user to programatically access the website bucket to be able to add, update, and delete files
data "aws_iam_policy_document" "access_policy" {
  statement {
    sid       = "S3PersonalWebsiteAccess"
    effect    = "Allow"
    actions   = [
      "s3:ListBucket",
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]
    resources = [
      aws_s3_bucket.website.arn,
      "${aws_s3_bucket.website.arn}/*"
    ]
  }
}

resource "aws_iam_policy" "access_policy" {
  name        = "S3PersonalWebsiteAccess"
  description = "Allows access to the personal website bucket to be able to add, update, and delete files"
  policy      = data.aws_iam_policy_document.access_policy.json
}

# Get the IP ranges of Cloudflare edge nodes
data "cloudflare_ip_ranges" "cloudflare" {}

# This policy will allow Cloudflare access to the S3 website bucket so that the website only responds to requests coming from the Cloudflare proxy
data "aws_iam_policy_document" "bucket_policy" {
  statement {
    sid       = "CloudflareGetObject"
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.website.arn}/*"]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"
      values   = concat(data.cloudflare_ip_ranges.cloudflare.ipv4_cidr_blocks, data.cloudflare_ip_ranges.cloudflare.ipv6_cidr_blocks)
    }
  }
}

resource "aws_s3_bucket_policy" "default" {
  bucket = aws_s3_bucket.website.id
  policy = data.aws_iam_policy_document.bucket_policy.json
}

# Create a DNS record to route the FQDN to the S3 website bucket endpoint
resource "cloudflare_record" "fqdn_cname" {
  zone_id = lookup(data.cloudflare_zones.selected.zones[0], "id")
  name    = var.fqdn
  type    = "CNAME"
  value   = aws_s3_bucket.website.website_endpoint
  proxied = true
}

# This S3 bucket will redirect all requests made to the apex domain over to the FQDN
resource "aws_s3_bucket" "redirect" {
  bucket = var.domain

  website {
    redirect_all_requests_to = var.fqdn
  }
}

# Block all public access for the redirect bucket
resource "aws_s3_bucket_public_access_block" "redirect" {
  bucket = aws_s3_bucket.redirect.id

  block_public_acls        = true
  block_public_policy      = true
  ignore_public_acls       = true
  restrict_public_buckets  = true
}

# Create a DNS record to route the apex domain to the S3 redirect bucket endpoint
resource "cloudflare_record" "apex_cname" {
  zone_id = lookup(data.cloudflare_zones.selected.zones[0], "id")
  name    = var.domain
  type    = "CNAME"
  value   = aws_s3_bucket.redirect.website_endpoint
  proxied = true
}