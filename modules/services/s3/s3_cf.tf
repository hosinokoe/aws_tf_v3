#resource "aws_s3_bucket" "s3" {
#  bucket = "${var.prefix_pro}-static"
#  acl    = "public-read"
#  tags = {
#    Name        = "${var.prefix_pro}-static"
#    Environment = "production"
#  }
#}

resource "aws_s3_bucket" "s3_pri" {
  for_each = toset(var.s3_private)
  bucket = each.value
  tags = {
    Name        = each.value
    Environment = "production"
  }
}

resource "aws_s3_bucket_public_access_block" "s3_pri_acl" {
  for_each = aws_s3_bucket.s3_pri
  bucket = each.key
  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

#resource "aws_s3_bucket" "s3_pri" {
#  count = length(var.s3_private)
#  bucket = var.s3_private[count.index]
#  tags = {
#    Name        = var.s3_private[count.index]
#    Environment = "production"
#  }
#}

#resource "aws_s3_bucket_public_access_block" "s3_pri_acl" {
#  count = "${length(var.s3_private)}"
#  bucket = aws_s3_bucket.s3_pri[count.index].id
#  block_public_acls   = true
#  block_public_policy = true
#  ignore_public_acls = true
#  restrict_public_buckets = true
#}

resource "aws_s3_bucket_policy" "s3" {
  bucket = aws_s3_bucket.s3.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression's result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "MYBUCKETPOLICY"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource = "${aws_s3_bucket.s3.arn}/*"
      },
    ]
  })
}


resource "aws_cloudfront_distribution" "s3_distribution" {
  count = "${var.number}"
  origin {
    domain_name = aws_s3_bucket.s3.bucket_regional_domain_name
    origin_id   = var.s3_origin_id

    #s3_origin_config {
    #  origin_access_identity = "origin-access-identity/cloudfront/ABCDEFG1234567"
    #}
  }

  enabled             = true
  is_ipv6_enabled     = false
  comment             = ""
  default_root_object = ""

  #logging_config {
  #  include_cookies = false
  #  bucket          = "mylogs.s3.amazonaws.com"
  #  prefix          = "myprefix"
  #}

  aliases = ["test-assets.stg.fp.minkabu.jp"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
    compress               = true
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
      #locations        = ["US", "CA", "GB", "DE"]
    }
  }

  tags = {
    Environment = "stg_test"
  }

  viewer_certificate {
    acm_certificate_arn = "arn:aws:acm:ap-northeast-1:426587536545:certificate/2eedd3dd-9091-47ff-975f-4d40eb70c197"
    ssl_support_method = "sni-only"
    minimum_protocol_version = "TLSv1.2_2019"
  }
}