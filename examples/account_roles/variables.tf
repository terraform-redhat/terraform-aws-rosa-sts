variable "account_role_prefix" {
  type = string
  default = ""
}

variable "ocm_environment" {
  type    = string
  default = "production"
}

variable "tags" {
  description = "(optional) List of AWS resource tags to apply."
  type        = map(string)
  default = {
    contact     = "xyz@company.com"
    cost-center = "12345"
    owner       = "productteam"
    environment = "test"
  }
}