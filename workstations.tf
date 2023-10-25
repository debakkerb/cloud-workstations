resource "google_workstations_workstation_cluster" "default" {
  provider               = google-beta
  project                = module.project.project_id
  workstation_cluster_id = var.workstation_cluster_id
  network                = google_compute_network.workstations.id
  subnetwork             = google_compute_subnetwork.workstations.id
  location               = var.region
  labels                 = var.labels
  display_name           = var.workstation_cluster_config.display_name

  private_cluster_config {
    enable_private_endpoint = var.workstation_cluster_config.enable_private_endpoint
  }
}

resource "google_workstations_workstation_config" "default" {
  provider               = google-beta
  project                = module.project.project_id
  location               = var.region
  workstation_cluster_id = google_workstations_workstation_cluster.default.id
  workstation_config_id  =
}