terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.21.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
  default_tags {
    tags = {
      Env   = "kurata-terraform-practice-step4"
      Owner = "kazunori_kurata"
    }
  }
}
