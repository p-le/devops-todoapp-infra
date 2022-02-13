resource "google_service_account" "node_pool" {
  count        = var.frontend_config.is_enabled || var.backend_config.is_enabled ? 1 : 0
  account_id   = "${var.service_name}-sa"
  display_name = "${var.service_name} Service Account"
}
