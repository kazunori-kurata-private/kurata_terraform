variable "pj" {
  type        = string
  description = "PJ名"
}

variable "app" {
  type        = string
  description = "APP名"
}

variable "instance-type" {
  type        = string
  description = "インスタンスタイプの指定"
}

variable "vpc-id" {
  type        = string
  description = "VPCのID"
}

variable "subnet-id" {
  type        = string
  description = "サブネットのID"
}

variable "allow-ingress-cidr" {
  type        = string
  description = "インバウンドを許可するCIDR"
}

variable "allow-tcp-ports" {
  type        = list(string)
  description = "インバウンドを許可するポート番号のリスト"
}
