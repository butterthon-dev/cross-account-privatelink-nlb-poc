variable "domain_name" {
  description = "証明書の主ドメイン名"
  type        = string
}

variable "subject_alternative_names" {
  description = "追加ドメイン (SAN)"
  type        = list(string)
  default     = []
}
