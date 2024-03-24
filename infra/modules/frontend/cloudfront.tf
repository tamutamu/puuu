resource "aws_cloudfront_function" "basicauth" {
  name    = "${local.app_id}_basicauth"
  runtime = "cloudfront-js-1.0"
  publish = true
  code = templatefile(
    "${path.module}/src/basicauth.js",
    {
      authString = base64encode("${var.basicauth_username}:${var.basicauth_password}")
    }
  )
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_cloudfront_distribution" "main" {
  aliases = [var.frontend_domain]

  default_root_object = "index.html"

  origin {
    origin_id                = aws_s3_bucket.app_bucket.id
    domain_name              = aws_s3_bucket.app_bucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.main.id
  }

  enabled = true

  # web_acl_id = aws_wafv2_web_acl.cloudfront.arn

  logging_config {
    bucket = aws_s3_bucket.cloudfront_log.bucket_domain_name
    # Cookieをログに含めるか
    include_cookies = false
    prefix          = "cloudfront/"
  }

  default_cache_behavior {
    target_origin_id       = aws_s3_bucket.app_bucket.id
    viewer_protocol_policy = "redirect-to-https"
    cached_methods         = ["GET", "HEAD"]
    allowed_methods        = ["GET", "HEAD"]
    # function_association {
    #   event_type   = "viewer-request"
    #   function_arn = aws_cloudfront_function.basicauth.arn
    # }
    cache_policy_id = data.aws_cloudfront_cache_policy.caching_optimized.id
    response_headers_policy_id = aws_cloudfront_response_headers_policy.cache_control.id
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # https://hisuiblog.com/error-aws-terraform-cloudfront-acm-cant-access/
  viewer_certificate {
    acm_certificate_arn      = var.aws_acm_certificate.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1"
  }

  depends_on = [
    var.aws_acm_certificate_validation,
    aws_wafv2_web_acl.cloudfront
  ]
}

data "aws_cloudfront_cache_policy" "caching_optimized" {
  name = "Managed-CachingOptimized"
}

resource "aws_cloudfront_response_headers_policy" "cache_control" {
  name    = "${local.app_id}_cache_control"

  custom_headers_config {
    items {
      header   = "Cache-Control"
      override = false
      value    = "max-age=300"
    }
  }
}

# OAC
resource "aws_cloudfront_origin_access_control" "main" {
  name                              = "${local.app_id}_oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}
