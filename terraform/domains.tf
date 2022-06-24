variable "primary_domain" {
    default = "openshaiya.org"
}

variable "archive_domain" {
    default = "archive.openshaiya.org"
}

variable "primary_domain_list" {
    type    = list(string)
    default = [
        "openshaiya.org",
        "www.openshaiya.org"
    ]
}

variable "archive_domain_list" {
    type    = list(string)
    default = [
        "archive.openshaiya.org",
        "www.archive.openshaiya.org"
    ]
}

variable "ssl_domains" {
    type    = list(string)
    default = [ 
        "openshaiya.org",
        "www.openshaiya.org",
        "archive.openshaiya.org",
        "www.archive.openshaiya.org"
     ]
}