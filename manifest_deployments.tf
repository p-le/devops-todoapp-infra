
data "kubectl_path_documents" "manifests" {
  pattern = "${path.module}/manifests/*.yaml"
}

resource "kubectl_manifest" "deployment_manifests" {
  count = fileexists("${path.module}/provider_gke.tf") ? 1 : 0
  depends_on = [
    google_container_node_pool.primary_nodes[0]
  ]
  yaml_body = element(data.kubectl_path_documents.manifests.documents, count.index)
}
