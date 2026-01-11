provider "aws" {
  region = "eu-central-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 5.29.0"
    }
  }

  backend "s3" {
    bucket = "s3-b-t-s1"
    key    = "bootstrap/terraform.tfstate"
    region = "eu-central-1"
  }

}