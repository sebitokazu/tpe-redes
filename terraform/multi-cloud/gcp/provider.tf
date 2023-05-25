provider "google" {
  alias       = "gcp"
  credentials = file("~/.gcp/credentials.json")
  project     = var.project_name
  region      = var.region
}