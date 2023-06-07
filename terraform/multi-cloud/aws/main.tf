provider "aws" {
  region = "us-east-1"

  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "default"

  default_tags {
    tags = {
      author     = "Grupo 3 - 1C2023"
      version    = 1
      university = "ITBA"
      subject    = "Redes"
      created-by = "terraform"
    }
  }
}

resource "aws_instance" "example" {
  ami           = "ami-0715c1897453cabd1"
  instance_type = "t2.micro"

  tags = {
    Name = "example-instance"
  }
}