terraform {
  required_providers {
    aws = {
      version = "= 5.21.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_vpc" "kurata_tf_test" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "kurata-tf-test"
  }
}
