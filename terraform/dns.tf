# Create a zone for the primary domain.
resource "aws_route53_zone" "primary" {
    name = var.primary_domain
}

# Issue an SSL certificate for the primary domain, and opt for validation
# via DNS records.
resource "aws_acm_certificate" "root_certificate" {
    domain_name                 = var.primary_domain
    subject_alternative_names   = var.ssl_domains
    validation_method           = "DNS"

    lifecycle {
        create_before_destroy = true
    }
}

# Add DNS records to the primary domain to validate the SSL certificate.
resource "aws_route53_record" "cert_validation" {
    for_each = {
        for dvo in aws_acm_certificate.root_certificate.domain_validation_options : dvo.domain_name => {
            name    = dvo.resource_record_name
            record  = dvo.resource_record_value
            type    = dvo.resource_record_type
        }
    }

    allow_overwrite = true
    name            = each.value.name
    records         = [each.value.record]
    ttl             = 60
    type            = each.value.type
    zone_id         = aws_route53_zone.primary.zone_id
}

# Add a DNS record for routing the primary domain to the CDN.
resource "aws_route53_record" "primary_domain" {
    zone_id = aws_route53_zone.primary.zone_id
    name    = var.primary_domain
    type    = "A"

    alias {
        name    = aws_cloudfront_distribution.cdn.domain_name
        zone_id = aws_cloudfront_distribution.cdn.hosted_zone_id
        evaluate_target_health = false
    }
}

# Add a DNS record for routing the `www` subdomain to the primary one.
resource "aws_route53_record" "primary_domain_www" {
    zone_id = aws_route53_zone.primary.zone_id
    name    = "www"
    type    = "CNAME"
    ttl     = 60

    records = [var.primary_domain]
}

# Add a DNS record for routing the archive domain to the CDN.
resource "aws_route53_record" "archive_domain" {
    zone_id = aws_route53_zone.primary.zone_id
    name    = var.archive_domain
    type    = "A"

    alias {
        name    = aws_cloudfront_distribution.archive_cdn.domain_name
        zone_id = aws_cloudfront_distribution.archive_cdn.hosted_zone_id
        evaluate_target_health = false
    }
}

# Add a DNS record for routing the `www` subdomain to the primary one.
resource "aws_route53_record" "archive_domain_www" {
    zone_id = aws_route53_zone.primary.zone_id
    name    = "www.${var.archive_domain}"
    type    = "CNAME"
    ttl     = 60

    records = [var.archive_domain]
}