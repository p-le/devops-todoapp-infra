resource "google_service_account" "node_pool" {
  count        = var.frontend_config.is_enabled || var.backend_config.is_enabled ? 1 : 0
  account_id   = "${var.service_name}-sa"
  display_name = "${var.service_name} Service Account"
}

# NOTE: Allow Node Pool instances has permission to connect to Cloud SQL Database
resource "google_project_iam_member" "sql_client" {
  count   = var.frontend_config.is_enabled || var.backend_config.is_enabled ? 1 : 0
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.node_pool[0].email}"
}

# NOTE: Setup Workload Identity between Node Pool Service Account <-> K8S Service Account: backend-sa
# So our backend pods will also have permission to connect to Cloud SQL
resource "google_service_account_iam_member" "workload_identity_user_backend" {
  count              = var.frontend_config.is_enabled || var.backend_config.is_enabled ? 1 : 0
  service_account_id = google_service_account.node_pool[0].name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[default/backend-sa]"
}

