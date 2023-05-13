terraform {
  required_version = ">= 1.0.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.67.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "4.64.0"
    }
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "2.4.0"
    }
  }
}