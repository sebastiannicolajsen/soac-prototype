variable GOOGLE_CRED_LOCATION {}


# install all required providers
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 3.61"
    }

  }
}

# setup default preferences
provider "aws" {
  profile = "default"
  region  = "eu-west-2"
}

provider "google" {
  project     = "terraform-308712"
  credentials = file(var.GOOGLE_CRED_LOCATION)
  region      = "europe-west4"
  zone        = "europe-west4-b"
}
