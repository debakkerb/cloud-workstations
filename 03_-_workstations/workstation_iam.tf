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

resource "google_workstations_workstation_iam_member" "oss_workstation_access" {
  count                  = var.create_oss_workstation ? 1 : 0
  provider               = google-beta
  member                 = "user:${local.admin_user}"
  role                   = "roles/workstation.user"
  workstation_cluster_id = google_workstations_workstation_cluster.default.workstation_cluster_id
  workstation_config_id  = google_workstations_workstation_config.oss_workstation_config.workstation_config_id
  workstation_id         = google_workstations_workstation.oss_workstation.0.workstation_id
  location               = local.region
}

resource "google_workstations_workstation_iam_member" "intellij_workstation_access" {
  count                  = var.create_intellij_workstation ? 1 : 0
  provider               = google-beta
  member                 = "user:${local.admin_user}"
  role                   = "roles/workstation.user"
  workstation_cluster_id = google_workstations_workstation_cluster.default.workstation_cluster_id
  workstation_config_id  = google_workstations_workstation_config.intellij_workstation_config.workstation_config_id
  workstation_id         = google_workstations_workstation.intellij_workstation.0.workstation_id
  location               = local.region
}

resource "google_project_iam_member" "workstation_project_access" {
  project = local.project_id
  member  = "serviceAccount:${google_service_account.workstation_host_identity.email}"
  role    = "roles/workstations.operationViewer"
}