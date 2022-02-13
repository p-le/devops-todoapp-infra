resource "local_file" "backend_manifests" {
  content = templatefile("${path.module}/templates/backend.yaml.tpl", {
    component  = "todoapp-backend",
    region     = var.region,
    project_id = var.project_id
    registry   = google_artifact_registry_repository.todoapp.name
    image_name = "todoapp-backend"
    image_tag  = var.backend_config.image_tag
  })
  filename = "${path.module}/manifests/backend.yaml"
}

resource "local_file" "frontend_manifests" {
  content = templatefile("${path.module}/templates/frontend.yaml.tpl", {
    component  = "todoapp-frontend",
    region     = var.region,
    project_id = var.project_id
    registry   = google_artifact_registry_repository.todoapp.name
    image_name = "todoapp-frontend"
    image_tag  = var.frontend_config.image_tag
  })
  filename = "${path.module}/manifests/frontend.yaml"
}

resource "local_file" "provider_gke" {
  count = var.frontend_config.is_enabled ? 1 : 0
  content = file("${path.module}/templates/provider_gke.tf.tpl")
  filename = "${path.module}/provider_gke.tf"
}
