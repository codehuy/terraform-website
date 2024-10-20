# backend variables
variable "state_bucket_name" {
  default = "terraform-huytran-state-bucket"
}

variable "state_table_name" {
  default = "terraform_state_table"
}

variable "terraform_iam_user_name" {
    default = "terraform_user"
}



# route53 variables
variable "root_domain" {
  default = "huy-tran.com"
}

variable "dns_record_ttl" {
  default = 300 
}


# S3 bucket variables
variable "website_bucket" {
  default = "huytran-website-bucket"
}

variable "force_destroy" {
  default = false
}

variable "versioning_enabled" {
  default = "Enabled"
}

variable "index_document" {
  default = "index.html"
}