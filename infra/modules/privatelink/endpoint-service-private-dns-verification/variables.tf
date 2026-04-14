variable "service_id" {
  description = "VPC Endpoint Service の ID"
  type        = string
}

variable "wait_for_verification" {
  description = "AWSが所有権検証完了状態になるまで apply を待機するか"
  type        = bool
  default     = true
}
