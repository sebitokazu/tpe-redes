provider "google" {
  credentials = file("encouraging-key-389101-3c5c4d7e2748.json")
  project     = "encouraging-key-389101"
  region      = "us-central1"
}

resource "google_storage_bucket" "bucket" {
  name     = var.bucket_name
  location = "us-central1"
  project  = "encouraging-key-389101"

  website {
    main_page_suffix = "index.html"
    not_found_page   = "error.html"
  }
}

resource "google_storage_bucket_object" "object" {
  name   = "index.html"
  bucket = google_storage_bucket.bucket.name
  source = "index.html" # This is your local index.html file
}

resource "google_compute_backend_bucket" "backend" {
  name        = "${var.bucket_name}-backend"
  bucket_name = google_storage_bucket.bucket.name
  enable_cdn  = true
}

resource "google_compute_url_map" "urlmap" {
  name            = "${var.bucket_name}-cd-url-map"
  default_service = google_compute_backend_bucket.backend.self_link
}

resource "google_compute_global_forwarding_rule" "default" {
  name       = "${var.bucket_name}-cd-forwarding-rule"
  target     = google_compute_target_http_proxy.default.self_link
  port_range = "80"
  ip_address = google_compute_global_address.default.address
}

resource "google_compute_target_http_proxy" "default" {
  name    = "${var.bucket_name}-cd-http-proxy"
  url_map = google_compute_url_map.urlmap.self_link
}

resource "google_compute_global_address" "default" {
  name = "${var.bucket_name}-cd-ip"
}

resource "google_storage_bucket_iam_member" "public_read_access" {
  bucket = google_storage_bucket.bucket.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}

variable "bucket_name" {
  description = "The name of the GCS bucket."
}
