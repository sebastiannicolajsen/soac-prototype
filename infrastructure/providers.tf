# install all required providers
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

# setup default preferences
provider "aws" {
  profile = "default"
  region  = "eu-west-2"
}
