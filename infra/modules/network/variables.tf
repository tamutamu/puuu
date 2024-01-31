variable "app" {
  type = string
}

variable "env" {
  type = string
}

variable "vpc" {
  type = map(string)
  default = {
    cidr = "10.0.0.0/16"
  }
}

variable "enable_dns_support" {
  type    = bool
  default = true
}

variable "enable_dns_hostnames" {
  type    = bool
  default = true
}

variable "igw_name" {
  type    = string
  default = "igw"
}

variable "public_subnet_a" {
  type = map(string)
  default = {
    cidr = ""
  }
}

variable "public_subnet_c" {
  type = map(string)
  default = {
    cidr = ""
  }
}

variable "private_subnet_a" {
  type = map(string)
  default = {
    cidr = ""
  }
}

variable "private_subnet_c" {
  type = map(string)
  default = {
    cidr = ""
  }
}
