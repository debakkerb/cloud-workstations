resource "google_artifact_registry_repository" "workstation_images" {
  project       = module.project.project_id
  format        = "DOCKER"
  repository_id = var.workstation_images_repository_id
  location      = var.region

  docker_config {
    immutable_tags = true
  }
}