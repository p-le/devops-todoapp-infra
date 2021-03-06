terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.8.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

resource "local_file" "provider_gke" {
  count    = var.frontend_config.is_enabled || var.backend_config.is_enabled ? 1 : 0
  content  = <<EOF
# NOTE: Dynamically generated only if GKE Cluster is created
module "gke_auth" {
  depends_on = [
    google_container_cluster.todoapp[0]
  ]
  source               = "terraform-google-modules/kubernetes-engine/google//modules/auth"
  project_id           = var.project_id
  cluster_name         = google_container_cluster.todoapp[0].name
  location             = data.google_compute_zones.available.names[0]
  use_private_endpoint = false
}

provider "kubernetes" {
  cluster_ca_certificate = module.gke_auth.cluster_ca_certificate
  host                   = module.gke_auth.host
  token                  = module.gke_auth.token
}

provider "kubectl" {
  cluster_ca_certificate = module.gke_auth.cluster_ca_certificate
  host                   = module.gke_auth.host
  token                  = module.gke_auth.token
  load_config_file       = false
}
EOF
  filename = "${path.module}/provider_gke.tf"
}
