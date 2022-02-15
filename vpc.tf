resource "google_compute_network" "vpc" {
  count                   = var.frontend_config.is_enabled || var.backend_config.is_enabled ? 1 : 0
  name                    = "${var.service_name}-vpc"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "subnet" {
  count         = var.frontend_config.is_enabled || var.backend_config.is_enabled ? 1 : 0
  name          = "${var.region}-${var.service_name}-subnet"
  region        = var.region
  network       = google_compute_network.vpc[0].name
  ip_cidr_range = "10.2.0.0/16"

  secondary_ip_range {
    range_name    = "services-range"
    ip_cidr_range = "192.168.1.0/24"
  }

  secondary_ip_range {
    range_name    = "pod-ranges"
    ip_cidr_range = "192.168.64.0/22"
  }
}

resource "google_compute_firewall" "default" {
  count   = var.frontend_config.is_enabled || var.backend_config.is_enabled ? 1 : 0
  name    = "${var.service_name}-nodepool-fw-default"
  network = google_compute_network.vpc[0].name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags   = [var.service_name]
  source_ranges = ["0.0.0.0/0"]
}
