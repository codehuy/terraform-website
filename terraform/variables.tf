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



# S3 bucket variables
variable "bucket_name" {
  default = "huytran-website-bucket"
}
