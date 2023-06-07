provider "google" {
  credentials = file("encouraging-key-389101-3c5c4d7e2748.json")
  project     = "encouraging-key-389101"
  region      = "us-central1"
}

resource "google_compute_instance" "default" {
  name         = "starter-instance"
  machine_type = "f1-micro"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "https://www.googleapis.com/compute/v1/projects/debian-cloud/global/images/family/debian-10"
    }
  }

  network_interface {
    network = "default"
    access_config {
      // Ephemeral IP
    }
  }

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}
