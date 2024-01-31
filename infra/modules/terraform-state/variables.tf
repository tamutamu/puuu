variable "app" {
  type = string
}

variable "env" {
  type = string
}


variable "force_destroy" {
  description = "bucket が空でなくても、強制的に bucket を削除できるようにするか否か"
  type        = bool
  default     = false
}
