# 基本的なTerraformの書き方・リソース削除

## Terraform実行ディレクトリの初期化
1. ディレクトリを移動
	  ```
	  PS C:\Users\kazu_\Repo\kurata_terraform> cd .\step3\
	  ```

	  ```
	  PS C:\Users\kazu_\Repo\kurata_terraform\step3> pwd

	  Path
	  ----
	  C:\Users\kazu_\Repo\kurata_terraform\step3
	  ```

1. 以下のコマンドを実行
	  ``` bash
	  aws-vault exec Kazu_IAMuser -- terraform init
	  ```

## countによるリソースの繰り返し
1. VPC・Subnet の変数定義
	  ```tf
	  # variables.tf
	  variable "vpc-cidr" {
		  type        = string
		  description = "VPCのCIDR"
	  }

	  variable "subnet-cidrs" {
		  type        = list(string)
		  description = "サブネットのCIDRのリスト"
	  }
	  ```

	  ```tf
	  # terraform.tfvars
	  vpc-cidr     = "10.1.0.0/16"
	  subnet-cidrs = ["10.1.10.0/24", "10.1.20.0/24"]
	  ```

1. リソース作成定義
	  ```tf
	  # main.tf
	  resource "aws_vpc" "kurata_tf_test" {
		  cidr_block = var.vpc-cidr
	  }

	  resource "aws_subnet" "count" {
		  count = length(var.subnet-cidrs)

		  vpc_id     = aws_vpc.kurata_tf_test.id
		  cidr_block = var.subnet-cidrs[count.index]
	  }
	  ```

1. ファイルのチェックからデプロイまで
	  ```bash
	  terraform fmt
	  terraform validate
	  aws-vault exec Kazu_IAMuser -- terraform plan
	  aws-vault exec Kazu_IAMuser -- terraform apply
	  ```

### サブネットの1つを削除した場合
1. Subnet の変数定義を修正
	  ```tf
	  # terraform.tfvars
	  vpc-cidr     = "10.1.0.0/16"
	  subnet-cidrs = ["10.1.20.0/24"]
	  ```

1. 以下コマンドを実行
	  ```bash
	  terraform fmt
	  terraform validate
	  aws-vault exec Kazu_IAMuser -- terraform plan
	  ```

1. インデックス0のリソースがreplacedになり、インデックス1のリソースがdestroyedになってしまう
	  ```
	  # aws_subnet.count[0] must be replaced
	  ///
	  # aws_subnet.count[1] will be destroyed
    # (because index [1] is out of range for count)
	  ///
	  ```

## for_eachによるリソースの繰り返し
1. 作成したSubnetリソースを削除（main.tf に記載したリソースをコメントアウトして terraform apply ）
	  ```tf
	  # resource "aws_subnet" "count" {
	  #   count = length(var.subnet-cidrs)

	  #   vpc_id     = aws_vpc.kurata_tf_test.id
	  #   cidr_block = var.subnet-cidrs[count.index]
	  # }
	  ```
	  ```bash
	  aws-vault exec Kazu_IAMuser -- terraform apply
	  ```

1. リソース作成定義
	  ```tf
	  # main.tf
	  resource "aws_subnet" "foreach" {
		  for_each = toset(var.subnet-cidrs)

		  vpc_id     = aws_vpc.kurata_tf_test.id
		  cidr_block = each.key
	  }
	  ```

1. ファイルのチェックからデプロイまで
	  ```bash
	  terraform fmt
	  terraform validate
	  aws-vault exec Kazu_IAMuser -- terraform plan
	  aws-vault exec Kazu_IAMuser -- terraform apply
	  ```

### サブネットの1つを削除した場合
1. Subnet の変数定義を修正
	  ```tf
	  # terraform.tfvars
	  vpc-cidr     = "10.1.0.0/16"
	  subnet-cidrs = ["10.1.20.0/24"]
	  ```

1. 以下コマンドを実行
	  ```bash
	  terraform fmt
	  terraform validate
	  aws-vault exec Kazu_IAMuser -- terraform plan
	  ```

1. 10.1.10.0/24のサブネットのみdestroyedされる
	  ```
	  # aws_subnet.foreach["10.1.10.0/24"] will be destroyed
    # (because key ["10.1.10.0/24"] is not in for_each map)
	  ```

## dynamicによるブロックの繰り返し
1. SecurityGroup のリソースを作成する。tcp:443を許可するルールを追加する。
	  ```tf
	  # main.tf
	  resource "aws_security_group" "dynamic" {
		  name        = "kurata-sg-dynamic-test"
		  description = "kurata sg dynamic Test"
		  vpc_id      = aws_vpc.kurata_tf_test.id

		  dynamic "ingress" {
			  for_each = toset(var.sg-allow-cidrs)
			  content {
				  description      = "TLS from VPC"
				  from_port        = 443
				  to_port          = 443
				  protocol         = "tcp"
				  cidr_blocks      = [ingress.key]    
			  }
		  }
	  }
	  ```

1. SecurityGroup に関する変数定義を行う。tcp:443アクセスを許可する5つのIPアドレスを定義する。
	  ```tf
	  # variables.tf
	  variable "sg-allow-cidrs" {
		  type        = list(string)
		  description = "SecurityGroupで許可するCIDRのリスト"
	  }
	  ```

	  ```tf
	  # terraform.tfvars
	  sg-allow-cidrs = ["10.1.10.10/32","10.1.10.11/32","10.1.10.12/32","10.1.10.13/32","10.1.10.14/32"]
	  ```

1. ファイルのチェックからデプロイまで
	  ```bash
	  terraform fmt
	  terraform validate
	  aws-vault exec Kazu_IAMuser -- terraform plan
	  aws-vault exec Kazu_IAMuser -- terraform apply
	  ```

## for_eachで SecurityGroup のルールをループさせる
1. main.tf でループの定義を変更する
	  ```tf
	    # dynamic "ingress" {
		  #   for_each = toset(var.sg-allow-cidrs)
		  #   content {
		  #     description = "TLS from VPC"
		  #     from_port   = 443
		  #     to_port     = 443
		  #     protocol    = "tcp"
		  #     cidr_blocks = [ingress.key]
		  #   }
		  # }

			  dynamic "ingress" {
				  for_each = var.sg-ingress-rulus
				  content {
					  description = "TLS from VPC"
					  from_port   = 443
					  to_port     = 443
					  protocol    = ingress.value.protocol
					  cidr_blocks = [ingress.key]
				  }
			  }
	  ```

1. SecurityGroup に関する変数定義を行う。
	  ```tf
	  # variables.tf
	  variable "sg-ingress-rulus" {
		  type = map(object({
			  protocol = string
		  }))
		  description = "SecurityGroupで許可するルールのオブジェクト"
	  }
	  ```

	  ```tf
	  # terraform.tfvars
	  sg-ingress-rulus = {
		  "10.1.10.10/32" = {
			  protocol = "TCP"
		  }
		  "10.1.10.11/32" = {
			  protocol = "TCP"
		  }
		  "10.1.10.12/32" = {
			  protocol = "UDP"
		  }
		  "10.1.10.13/32" = {
			  protocol = "UDP"
		  }
		  "10.1.10.14/32" = {
			  protocol = "UDP"
		  }
	  }
	  ```

1. ファイルのチェックからデプロイまで
	  ```bash
	  terraform fmt
	  terraform validate
	  # 3つのIPアドレスに関して、プロトコルUDPに変更になる
	  aws-vault exec Kazu_IAMuser -- terraform plan
	  aws-vault exec Kazu_IAMuser -- terraform apply
	  ```

## 繰り返しで作成したリソースのoutput
1. Subnet・SecurityGroup を output
	  ```tf
	  # output.tf
	  output "dynamic-sg-id" {
		  value = aws_security_group.dynamic.id
	  }

	  output "subnets" {
		  value = [for key, value in aws_subnet.foreach : value.id]
	  }
	  ```

1. ファイルのチェックからデプロイまで
	  ```bash
	  terraform fmt
	  terraform validate
	  aws-vault exec Kazu_IAMuser -- terraform plan
	  aws-vault exec Kazu_IAMuser -- terraform apply
	  ```

## リソースの削除
1. 以下のコマンドを実行する
    ```bash
    aws-vault exec Kazu_IAMuser -- terraform destroy
    ```
