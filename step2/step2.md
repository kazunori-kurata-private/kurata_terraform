# 基本的なTerraformの書き方・リソース削除

## 各 .tfファイル .tfvarsファイルの作成
1. AWS Providerのバージョン、VPC名、タグ名を変更

## Terraform実行ディレクトリの初期化
1. ディレクトリを移動
    ```
    PS C:\Users\kazu_\Repo\kurata_terraform> cd .\step2\
    ```
	
    ```
    PS C:\Users\kazu_\Repo\kurata_terraform\step2> pwd

    Path
    ----
    C:\Users\kazu_\Repo\kurata_terraform\step2
    ```

1. 以下のコマンドを実行
	  ``` bash
	  aws-vault exec Kazu_IAMuser -- terraform init
	  ```

## ファイルのチェックをする
1. 以下のコマンドを実行
    ```bash
    # ファイルを成形。問題なければ何も表示されない。
    terraform fmt
    ```

1. 以下のコマンドを実行
    ```bash
    # 構文チェック。問題なければ、「Success! The configuration is valid.」と表示される。
    terraform validate
    ```

## デプロイされるリソースの内容を確認
1. 以下のコマンドを実行
	  ```bash
     # エラーがないことを確認する。
	  aws-vault exec Kazu_IAMuser -- terraform plan
	  ```

## リソースのデプロイ
1. 以下のコマンドを実行
	  ```bash
	  aws-vault exec Kazu_IAMuser -- terraform apply
	  ```

1. 以下の表示がされていればよい
	  ```
	  Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
	  ```

## リソースの削除
今回は `destroy` ではなく、ファイルのコメントアウトによるリソース削除を行う

1. `main.tf` 及び `output.tf` の内容をコメントアウトする

1. 以下のコマンドを実行する
    ```bash
    aws-vault exec Kazu_IAMuser -- terraform plan
    aws-vault exec Kazu_IAMuser -- terraform apply
    ```

1. 以下の表示がされることを確認する
    ```
    Apply complete! Resources: 0 added, 0 changed, 2 destroyed.
    ```
