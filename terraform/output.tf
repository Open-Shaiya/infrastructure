output "primary_domain_nameservers" {
    value = resource.aws_route53_zone.primary.name_servers
}

resource "local_file" "vars" {
    content = templatefile("templates/vars.tmpl",
    {
        primary_domain  = var.primary_domain,
        primary_bucket  = resource.aws_s3_bucket.prod_website.id,
        archive_bucket  = resource.aws_s3_bucket.archive.id
    })
    filename = "../ansible/vars.yml"
}