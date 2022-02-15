resource "google_storage_bucket" "todoapp" {
  count         = var.db_config.is_enabled ? 1 : 0
  name          = "${var.service_name}-${var.region}-sql"
  location      = upper(var.region)
  force_destroy = true
}

resource "google_storage_bucket_object" "todoapp_tables" {
  count   = var.db_config.is_enabled ? 1 : 0
  name    = "tables.sql"
  content = data.http.db_migration_tables.body
  bucket  = google_storage_bucket.todoapp[0].name
}
