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
  project                = local.project_id
  workstation_cluster_id = var.workstation_cluster_id
  network                = local.network_id
  subnetwork             = local.subnet_id
  location               = local.region
  labels                 = local.labels
  display_name           = var.workstation_cluster_config.display_name
}
