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

resource "google_service_account" "scheduled_trigger_identity" {
  project    = local.project_id
  account_id = "workstation-scheduler-identity"
}

resource "google_project_iam_member" "scheduled_trigger_identity_permissions" {
  for_each = toset([
    "roles/cloudbuild.builds.editor"
  ])
  project = local.project_id
  member  = "serviceAccount:${google_service_account.scheduled_trigger_identity.email}"
  role    = each.value
}

resource "google_service_account_iam_member" "scheduler_cloud_build_impersonation" {
  member             = "serviceAccount:${google_service_account.scheduled_trigger_identity.email}"
  role               = "roles/iam.serviceAccountUser"
  service_account_id = google_service_account.cloudbuild_identity.id
}

resource "google_cloud_scheduler_job" "intellij_ws_image_schedule" {
  project          = local.project_id
  name             = "intellij-workstation-image-schedule"
  region           = local.region
  schedule         = "0 1 * * *"
  attempt_deadline = "600s"
  time_zone        = "Europe/Amsterdam"

  http_target {
    http_method = "POST"
    uri         = "https://cloudbuild.googleapis.com/v1/projects/${local.project_id}/locations/${local.region}/triggers/${google_cloudbuild_trigger.intellij_ws_image_trigger.trigger_id}:run"
    oauth_token {
      service_account_email = google_service_account.scheduled_trigger_identity.email
      scope                 = "https://www.googleapis.com/auth/cloud-platform"
    }
  }
}

resource "google_cloud_scheduler_job" "oss_ws_image_schedule" {
  project          = local.project_id
  name             = "oss-workstation-image-schedule"
  region           = local.region
  schedule         = "0 1 * * *"
  attempt_deadline = "600s"
  time_zone        = "Europe/Amsterdam"

  http_target {
    http_method = "POST"
    uri         = "https://cloudbuild.googleapis.com/v1/projects/${local.project_id}/locations/${local.region}/triggers/${google_cloudbuild_trigger.oss_ws_image_trigger.trigger_id}:run"
    oauth_token {
      service_account_email = google_service_account.scheduled_trigger_identity.email
      scope                 = "https://www.googleapis.com/auth/cloud-platform"
    }
  }
}
