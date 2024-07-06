# 実行結果まとめ

## tfvars 設定内容
```tf
pj = "kurata-step7"

vpc-cidr    = "10.1.0.0/16"
subnet-cidr = "10.1.10.0/24"

instance-type = "t3.micro"

allow-ingress-cidr = "14.3.46.171/32"
allow-tcp-ports    = ["80", "443"]
```

## コンソール確認

### VPC
Name/CIDR 確認
![alt text](./doc/vpc.png)

### サブネット
Name/CIDR 確認
![alt text](./doc/subnet.png)

### app = front のとき

#### EC2
Name 確認
![alt text](./doc/ec2-front-name.png)

AMI 確認
![alt text](./doc/ec2-front-ami.png)

紐づくサブネット確認
![alt text](./doc/ec2-front-subnet.png)

紐づくセキュリティグループ確認
![alt text](./doc/ec2-front-sg.png)

デバイス暗号化確認
![alt text](./doc/ec2-front-ebs.png)

#### S3（なし）
![alt text](./doc/s3-none.png)

### app = back のとき

#### EC2
Name 確認
![alt text](./doc/ec2-back-name.png)

紐づくサブネット確認
![alt text](./doc/ec2-back-subnet.png)

紐づくセキュリティグループ確認
![alt text](./doc/ec2-back-sg.png)

デバイス暗号化なし確認
![alt text](./doc/ec2-back-ebs.png)

#### S3（あり）
![alt text](./doc/s3.png)
