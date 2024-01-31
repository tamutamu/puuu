variable "app" {
  type = string
}

variable "env" {
  type = string
}

variable "domain" {
  type = string
}

variable "frontend_domain" {
  type = string
}


variable "aws_acm_certificate" {
  type = any
}

variable "aws_acm_certificate_validation" {
  type = any
}

variable "basicauth_username" {
  type    = string
  default = "user"
}

variable "basicauth_password" {
  type      = string
  default   = "p@ssw0rd1234"
  sensitive = true
}
