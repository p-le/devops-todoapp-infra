data "google_compute_zones" "available" {
  region = var.region
}

# NOTE: Read SQL file content from backend repository
data "http" "db_migration_tables" {
  url = "https://raw.githubusercontent.com/p-le/test-todoapp-backend/master/migrations/tables.sql"
}
