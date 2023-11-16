/**
 * Copyright 2023 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
 
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