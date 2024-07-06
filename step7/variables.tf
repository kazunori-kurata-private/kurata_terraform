variable "pj" {
  type        = string
  description = "PJ名"
}

variable "vpc-cidr" {
  type        = string
  description = "VPCのCIDR"
}

variable "subnet-cidr" {
  type        = string
  description = "サブネットのCIDR"
}

variable "instance-type" {
  type        = string
  description = "インスタンスタイプの指定"
}

variable "allow-ingress-cidr" {
  type        = string
  description = "インバウンドを許可するCIDR"
}

variable "allow-tcp-ports" {
  type        = list(string)
  description = "インバウンドを許可するポート番号のリスト"
}
