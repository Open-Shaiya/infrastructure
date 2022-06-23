resource "aws_cloudfront_distribution" "cdn" {
    origin {
        origin_id   = local.s3_bucket_origin
        domain_name = resource.aws_s3_bucket.prod_website.bucket_regional_domain_name
    }

    aliases             = var.ssl_domains
    default_root_object = "index.html"
    enabled             = true
    is_ipv6_enabled     = true
    price_class         = "PriceClass_100"  # NA and EU only (USA, Canada, Mexico, Europe, Israel).

    default_cache_behavior {
        allowed_methods     = ["HEAD", "DELETE", "POST", "GET", "OPTIONS", "PUT", "PATCH"]
        cached_methods      = ["GET", "HEAD"]
        target_origin_id    = local.s3_bucket_origin

        forwarded_values {
            query_string = true
            cookies {
                forward = "all"
            }
        }

        viewer_protocol_policy  = "redirect-to-https"
        compress                = true
        min_ttl                 = 0
        default_ttl             = 3600
        max_ttl                 = 86400 
    }

    restrictions {
        geo_restriction {
            restriction_type    = "none"
            locations           = [] 
        }
    }

    viewer_certificate {
        acm_certificate_arn = aws_acm_certificate.root_certificate.arn
        ssl_support_method  = "sni-only"
    }
}
