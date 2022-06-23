variable "primary_domain" {
    default = "openshaiya.org"
}

variable "ssl_domains" {
    type    = list(string)
    default = [ 
        "openshaiya.org",
        "www.openshaiya.org"
     ]
}