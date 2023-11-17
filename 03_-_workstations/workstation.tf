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

resource "google_service_account" "workstation_host_identity" {
  project     = local.project_id
  account_id  = "workstation-host-identity"
  description = "Service account attached to the VM hosting the Workstation container"
}

resource "google_artifact_registry_repository_iam_member" "workstation_host_identity_image_access" {
  project    = local.project_id
  member     = "serviceAccount:${google_service_account.workstation_host_identity.email}"
  repository = local.artifact_registry_name
  role       = "roles/artifactregistry.reader"
  location   = local.region
}

resource "google_workstations_workstation_config" "intellij_workstation_config" {
  provider               = google-beta
  project                = local.project_id
  location               = local.region
  workstation_cluster_id = google_workstations_workstation_cluster.default.workstation_cluster_id
  workstation_config_id  = "intellij-ide-config"
  display_name           = "Intellij IDE Workstation Config"
  idle_timeout           = "7200s"

  container {
    image = local.intellij_ws_image_full_name
  }

  host {
    gce_instance {
      machine_type                = var.workstation_host_config.machine_type
      disable_public_ip_addresses = var.workstation_host_config.disable_public_ip_addresses
      service_account             = google_service_account.workstation_host_identity.email
      shielded_instance_config {
        enable_secure_boot          = var.workstation_host_config.shielded_instance_config.enable_secure_boot
        enable_vtpm                 = var.workstation_host_config.shielded_instance_config.enable_vtpm
        enable_integrity_monitoring = var.workstation_host_config.shielded_instance_config.enable_integrity_monitoring
      }
    }
  }

  persistent_directories {
    mount_path = var.workstation_directories_config.mount_path
    gce_pd {
      size_gb        = var.workstation_directories_config.gce_pd.size_gb
      fs_type        = var.workstation_directories_config.gce_pd.fs_type
      disk_type      = var.workstation_directories_config.gce_pd.disk_type
      reclaim_policy = var.workstation_directories_config.gce_pd.reclaim_policy
    }
  }
}

resource "google_workstations_workstation_config" "oss_workstation_config" {
  provider               = google-beta
  project                = local.project_id
  location               = local.region
  workstation_cluster_id = google_workstations_workstation_cluster.default.workstation_cluster_id
  workstation_config_id  = "oss-ide-config"
  display_name           = "OSS IDE Workstation Config"
  idle_timeout           = "7200s"

  container {
    image = local.oss_ws_image_full_name
  }

  host {
    gce_instance {
      machine_type                = var.workstation_host_config.machine_type
      disable_public_ip_addresses = var.workstation_host_config.disable_public_ip_addresses
      service_account             = google_service_account.workstation_host_identity.email
      shielded_instance_config {
        enable_secure_boot          = var.workstation_host_config.shielded_instance_config.enable_secure_boot
        enable_vtpm                 = var.workstation_host_config.shielded_instance_config.enable_vtpm
        enable_integrity_monitoring = var.workstation_host_config.shielded_instance_config.enable_integrity_monitoring
      }
    }
  }

  persistent_directories {
    mount_path = var.workstation_directories_config.mount_path
    gce_pd {
      size_gb        = var.workstation_directories_config.gce_pd.size_gb
      fs_type        = var.workstation_directories_config.gce_pd.fs_type
      disk_type      = var.workstation_directories_config.gce_pd.disk_type
      reclaim_policy = var.workstation_directories_config.gce_pd.reclaim_policy
    }
  }
}

resource "google_workstations_workstation" "intellij_workstation" {
  count                  = var.create_intellij_workstation ? 1 : 0
  provider               = google-beta
  project                = local.project_id
  location               = local.region
  workstation_cluster_id = google_workstations_workstation_cluster.default.workstation_cluster_id
  workstation_config_id  = google_workstations_workstation_config.intellij_workstation_config.workstation_config_id
  workstation_id         = "intellij-workstation"
  display_name           = "Intellij Workstation - "
  labels                 = local.labels
}

resource "google_workstations_workstation" "oss_workstation" {
  count                  = var.create_oss_workstation ? 1 : 0
  provider               = google-beta
  project                = local.project_id
  location               = local.region
  workstation_cluster_id = google_workstations_workstation_cluster.default.workstation_cluster_id
  workstation_config_id  = google_workstations_workstation_config.oss_workstation_config.workstation_config_id
  workstation_id         = "oss-workstation"
  display_name           = "OSS Workstation"
  labels                 = local.labels
}

