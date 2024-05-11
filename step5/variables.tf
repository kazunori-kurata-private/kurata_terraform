variable "vpc-cidr" {
  type        = string
  description = "VPCのCIDR"
}

variable "subnet-cidrs" {
  type        = list(string)
  description = "サブネットのCIDR"
}

variable "instance-type" {
  type        = string
  description = "インスタンスタイプの指定"
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
