variable "vpc-cidr" {
  type        = string
  description = "VPCのCIDR"
}

variable "dev" {
  type        = bool
  description = "変数分岐用"
}

variable "subnet-cidrs" {
  type        = list(string)
  description = "サブネットのCIDR"
}

# variable "sg-allow-cidrs" {
#   type        = list(string)
#   description = "SecurityGroupで許可するCIDRのリスト"
# }

# variable "sg-ingress-rulus" {
#   type = map(object({
#     protocol = string
#   }))
#   description = "SecurityGroupで許可するルールのオブジェクト"
# }
