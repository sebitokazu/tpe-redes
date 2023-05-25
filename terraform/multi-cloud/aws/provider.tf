provider "aws" {
  alias  = "aws"
  region = var.region

  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "default"

  default_tags {
    tags = {
      author     = "Grupo 3 - 1C2023"
      version    = 1
      university = "ITBA"
      subject    = "Redes"
    }
  }
}