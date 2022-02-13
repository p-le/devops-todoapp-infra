resource "google_container_cluster" "todoapp" {
  count       = var.frontend_config.is_enabled || var.backend_config.is_enabled ? 1 : 0
  name        = "${var.service_name}-cluster"
  description = "Cluster for Todoapp Demo"
  location    = data.google_compute_zones.available.names[0]
  network     = google_compute_network.vpc[0].id
  subnetwork  = google_compute_subnetwork.subnet[0].id
  ip_allocation_policy {
    cluster_secondary_range_name  = google_compute_subnetwork.subnet[0].secondary_ip_range.0.range_name
    services_secondary_range_name = google_compute_subnetwork.subnet[0].secondary_ip_range.1.range_name
  }
  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "primary_nodes" {
  count              = var.frontend_config.is_enabled || var.backend_config.is_enabled ? 1 : 0
  name               = "${var.service_name}-pool"
  location           = data.google_compute_zones.available.names[0]
  cluster            = google_container_cluster.todoapp[0].name
  initial_node_count = 1
  max_pods_per_node  = 16

  node_config {
    preemptible     = false
    machine_type    = "e2-medium"
    tags            = ["devops-demo"]
    service_account = google_service_account.node_pool[0].email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  autoscaling {
    min_node_count = 1
    max_node_count = 4
  }
}
