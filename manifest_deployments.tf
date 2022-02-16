
# NOTE: If provider_gke.tf exists, we will deploy all Kubernetes Manifest files
data "kubectl_file_documents" "backend" {
  count = fileexists("${path.module}/provider_gke.tf") ? 1 : 0
  content = templatefile("${path.module}/manifests/backend.yaml", {
    ROLE                        = "todoapp-backend",
    REGION                      = var.region,
    PROJECT_ID                  = var.project_id
    REPLICAS                    = var.backend_config.pod_replicas
    REPOSITORY_NAME             = google_artifact_registry_repository.todoapp.name
    IMAGE_NAME                  = "todoapp-backend"
    IMAGE_TAG                   = var.backend_config.image_tag
    SERVICE_ACCOUNT_EMAIL       = google_service_account.node_pool[0].email
    DB_USER                     = var.db_config.db_user
    DB_PASSWORD                 = var.db_config.db_password
    DB_INSTANCE_CONNECTION_NAME = google_sql_database_instance.todoapp[0].connection_name
  })
}

data "kubectl_file_documents" "frontend" {
  count = fileexists("${path.module}/provider_gke.tf") ? 1 : 0
  content = templatefile("${path.module}/manifests/frontend.yaml", {
    ROLE            = "todoapp-frontend",
    REGION          = var.region,
    REPLICAS        = var.frontend_config.pod_replicas
    PROJECT_ID      = var.project_id
    REPOSITORY_NAME = google_artifact_registry_repository.todoapp.name
    IMAGE_NAME      = "todoapp-frontend"
    IMAGE_TAG       = var.frontend_config.image_tag
  })
}

data "kubectl_file_documents" "ingress" {
  count = fileexists("${path.module}/provider_gke.tf") ? 1 : 0
  content = templatefile("${path.module}/manifests/ingress.yaml", {
    ROLE             = "todoapp-ingress",
    FRONTEND_SERVICE = "todoapp-frontend-service"
    BACKEND_SERVICE  = "todoapp-backend-service"
  })
}

resource "kubectl_manifest" "backend" {
  count = fileexists("${path.module}/provider_gke.tf") ? length(data.kubectl_file_documents.backend[0].documents) : 0
  depends_on = [
    google_container_node_pool.primary_nodes[0]
  ]
  yaml_body = element(data.kubectl_file_documents.backend[0].documents, count.index)
}

resource "kubectl_manifest" "frontend" {
  count = fileexists("${path.module}/provider_gke.tf") ? length(data.kubectl_file_documents.frontend[0].documents) : 0
  depends_on = [
    google_container_node_pool.primary_nodes[0]
  ]
  yaml_body = element(data.kubectl_file_documents.frontend[0].documents, count.index)
}

resource "kubectl_manifest" "ingress" {
  count = fileexists("${path.module}/provider_gke.tf") ? length(data.kubectl_file_documents.ingress[0].documents) : 0
  depends_on = [
    google_container_node_pool.primary_nodes[0]
  ]
  yaml_body = element(data.kubectl_file_documents.ingress[0].documents, count.index)
}
