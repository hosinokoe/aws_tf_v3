# s3_uploads新建，有zabbix，有cf，添加cors
resource "aws_s3_bucket" "s3_pub" {
  for_each = toset(var.s3_public)
  bucket = each.value
  acl    = "public-read"

  cors_rule {
    allowed_headers = ["Authorization","x-requested-with","origin","Content-Type","User-Agent"]
    allowed_methods = ["HEAD","GET","PUT"]
    allowed_origins = ["https://${var.domain}","http://${var.domain}"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
  tags = {
    Name        = each.value
  #  Environment = "production"
  }
}

resource "aws_s3_bucket_policy" "s3_pub_acl" {
  for_each = aws_s3_bucket.s3_pub
  bucket = each.key
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "MYBUCKETPOLICY"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource = "${aws_s3_bucket.s3_pub[each.key].arn}/*"
        # Resource = "${each.key.arn}/*"
      },
    ]
  })
}

resource "aws_s3_bucket" "s3_pri" {
  for_each = toset(var.s3_private)
  bucket = each.value
  tags = {
    Name        = each.value
    # Environment = "production"
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

resource "aws_iam_user" "zabbix" {
  name = "zabbix"
  path = "/users/"
}

resource "aws_iam_user_policy_attachment" "zabbix" {
  user       = aws_iam_user.zabbix.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess"
}

resource "aws_iam_user" "s3_uploads" {
  for_each = toset(var.s3_user)
  name = each.value
  path = "/users/"
}

resource "aws_iam_group_membership" "team" {
  name = "s3_uploads group"
  users = var.s3_user
  group = aws_iam_group.s3_uploads.name
}

resource "aws_iam_group" "s3_uploads" {
  name = "s3_uploads"
  path = "/users/"
}

resource "aws_iam_group_policy" "s3_uploads" {
  name        = "s3_uploads"
  group = aws_iam_group.s3_uploads.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = ["s3:ListAllMyBuckets","s3:GetBucketLocation"],
        Effect   = "Allow"
        "Resource": "arn:aws:s3:::*",
      },
      {
        "Effect" : "Allow",
        "Action" : "s3:*",
        "Resource": ["arn:aws:s3:::$${aws:username}","arn:aws:s3:::$${aws:username}/*"],
      }
    ]
  })
}


resource "aws_cloudfront_distribution" "s3_distribution" {
  for_each = toset(var.s3_public)
  origin {
    domain_name = aws_s3_bucket.s3_pub[each.key].bucket_regional_domain_name
    # origin_id   = var.s3_origin_id
    origin_id   = "myS3Origin"

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

  aliases = ["${var.aliases[each.key][0]}-assets.${var.domain}"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    # target_origin_id = var.s3_origin_id
    target_origin_id = "myS3Origin"

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

  # tags = {
  #   Environment = "stg_test"
  # }

  viewer_certificate {
    acm_certificate_arn = var.cert
    ssl_support_method = "sni-only"
    minimum_protocol_version = "TLSv1.2_2019"
  }
}

output "aws_iam_user" {
  value = aws_iam_user.s3_uploads
}
output "cf_domain" {
  value = [for s3_distribution in aws_cloudfront_distribution.s3_distribution : s3_distribution.domain_name]
}
output "cf_hostzone" {
  value = [for s3_distribution in aws_cloudfront_distribution.s3_distribution : s3_distribution.hosted_zone_id]
}