# 基本的なTerraformの書き方・リソース削除

## Terraform実行ディレクトリの初期化
1. ディレクトリを移動
	  ```
	  PS C:\Users\kazu_\Repo\kurata_terraform> cd .\step4\
	  ```

	  ```
	  PS C:\Users\kazu_\Repo\kurata_terraform\step4> pwd

	  Path
	  ----
	  C:\Users\kazu_\Repo\kurata_terraform\step4
	  ```

1. 以下のコマンドを実行
	  ``` bash
	  aws-vault exec Kazu_IAMuser -- terraform init
	  ```

## 変数によるパラメータの分岐
1. VPC・条件 の変数定義
	  ```tf
	  # variables.tf
	  variable "vpc-cidr" {
      type        = string
      description = "VPCのCIDR"
    }

    variable "dev" {
      type        = bool
      description = "変数分岐用"
    }
	  ```

	  ```tf
	  # terraform.tfvars
	  vpc-cidr = "10.1.0.0/16"
    dev      = true
	  ```

1. リソース作成定義
	  ```tf
	  # main.tf
	  resource "aws_vpc" "kurata_tf_test" {
      cidr_block = var.vpc-cidr

      enable_dns_support   = var.dev == true ? true : false
      enable_dns_hostnames = var.dev == true ? true : false

      tags = {
        Name = "kurata-tf-test-step4"
      }
    }
	  ```

    ```tf
    # output.tf
    output "vpc_id" {
      value = aws_vpc.kurata_tf_test.id
    }
    ```

1. ファイルのチェックからデプロイまで
	  ```bash
	  terraform fmt
	  terraform validate
	  aws-vault exec Kazu_IAMuser -- terraform plan
	  aws-vault exec Kazu_IAMuser -- terraform apply
	  ```

1. 作成したリソースの確認（★）
    ```bash
    aws-vault exec Kazu_IAMuser -- aws ec2 describe-vpc-attribute --attribute enableDnsSupport --vpc-id <vpc id>
    aws-vault exec Kazu_IAMuser -- aws ec2 describe-vpc-attribute --attribute enableDnsHostnames --vpc-id <vpc id>
    ```

1. `dev`を`false`に設定する
    ```tf
	  # terraform.tfvars
    dev      = false
	  ```

1. 再度ファイルのチェックからデプロイまで
	  ```bash
	  terraform fmt
	  terraform validate
	  aws-vault exec Kazu_IAMuser -- terraform plan
	  aws-vault exec Kazu_IAMuser -- terraform apply
	  ```

1. ★で、Value が false になっていることを確認する。

## `for_each`でのリソース分岐
1. サブネット関連の変数追加
	  ```tf
	  # variables.tf
	  variable "subnet-cidr" {
      type        = list(string)
      description = "サブネットのCIDR"
    }
	  ```

	  ```tf
	  # terraform.tfvars
	  subnet-cidr = ["10.1.10.0/24"]
	  ```

1. サブネット作成定義
	  ```tf
	  # main.tf
	  resource "aws_subnet" "foreach" {
      for_each = var.dev == true ? toset(var.subnet-cidr) : []

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

1. 作成したサブネットの確認
    ```bash
    aws-vault exec Kazu_IAMuser -- aws ec2 describe-subnets --filters "Name=tag-value,Values=kurata-terraform-practice-step4"
    ```

1. `dev`を`false`に設定する
    ```tf
	  # terraform.tfvars
    dev      = false
	  ```

1. 再度ファイルのチェックから`terraform plan`まで行い、サブネットが削除予定であることを確認する。
	  ```bash
	  terraform fmt
	  terraform validate
	  aws-vault exec Kazu_IAMuser -- terraform plan
	  ```

## ループも回す場合
1. サブネット関連の変数修正
	  ```tf
	  # variables.tf
	  variable "subnet-cidrs" {
      type        = list(string)
      description = "サブネットのCIDR"
    }
	  ```

	  ```tf
	  # terraform.tfvars
	  subnet-cidrs = ["10.1.10.0/24", "10.1.20.0/24"]
	  ```

1. サブネット作成定義修正
	  ```tf
	  # main.tf
	  resource "aws_subnet" "foreach" {
      for_each = var.dev == true ? toset(var.subnet-cidrs) : toset([])

      vpc_id     = aws_vpc.kurata_tf_test.id
      cidr_block = each.key
    }
	  ```

1. ファイルのチェックからデプロイまで（`10.1.20.0/24`のサブネットが追加されていればよい）
	  ```bash
	  terraform fmt
	  terraform validate
	  aws-vault exec Kazu_IAMuser -- terraform plan
	  aws-vault exec Kazu_IAMuser -- terraform apply
	  ```

1. 作成したサブネットの確認（2つのサブネットがあることを確認）
    ```bash
    aws-vault exec Kazu_IAMuser -- aws ec2 describe-subnets --filters "Name=tag-value,Values=kurata-terraform-practice-step4"
    ```

1. `dev`を`false`に設定する
    ```tf
	  # terraform.tfvars
    dev      = false
	  ```

1. 再度ファイルのチェックから`terraform plan`まで行い、2つのサブネットが削除予定であることを確認する。
	  ```bash
	  terraform fmt
	  terraform validate
	  aws-vault exec Kazu_IAMuser -- terraform plan
	  ```

## リソースの削除
1. 以下のコマンドを実行する
    ```bash
    aws-vault exec Kazu_IAMuser -- terraform destroy
    ```
