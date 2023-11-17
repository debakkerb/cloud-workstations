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

resource "google_service_account" "cloudbuild_identity" {
  project     = local.project_id
  account_id  = "cloud-build-custom-identity"
  description = "Identity used by Cloud Build pipelines to create Google Cloud resources"
}

resource "google_project_iam_member" "cloudbuild_identity_project_permissions" {
  for_each = toset(["roles/logging.logWriter"])
  project  = local.project_id
  member   = "serviceAccount:${google_service_account.cloudbuild_identity.email}"
  role     = each.value
}

resource "google_sourcerepo_repository_iam_member" "cloud_build_scr_access" {
  project    = local.project_id
  member     = "serviceAccount:${google_service_account.cloudbuild_identity.email}"
  repository = local.source_repo_name
  role       = "roles/source.reader"
}

resource "google_artifact_registry_repository_iam_member" "cloud_build_ar_access" {
  project    = local.project_id
  member     = "serviceAccount:${google_service_account.cloudbuild_identity.email}"
  repository = google_artifact_registry_repository.workstation_images.id
  role       = "roles/artifactregistry.writer"
}

resource "google_cloudbuild_trigger" "intellij_ws_image_trigger" {
  project         = local.project_id
  name            = "intellij-ws-image-trigger"
  description     = "Cloud Build trigger that runs on a schedule and builds the Intellij Workstation Image"
  service_account = google_service_account.cloudbuild_identity.id
  location        = local.region

  source_to_build {
    ref       = "refs/heads/main"
    repo_type = "CLOUD_SOURCE_REPOSITORIES"
    uri       = local.source_repo_url
  }

  git_file_source {
    path      = "00_-_modules/workstation-image/cloudbuild.yaml"
    repo_type = "CLOUD_SOURCE_REPOSITORIES"
    revision  = "/refs/heads/main"
  }

  substitutions = {
    _IMAGE_REPOSITORY_NAME = local.workstation_registry_repository_name
    _IDE_NAME              = "intellij"
    _IMAGE_TAG             = "latest"
    _WORKING_DIR           = "00_-_modules/workstation-image"
  }
}

resource "google_cloudbuild_trigger" "oss_ws_image_trigger" {
  project         = local.project_id
  name            = "oss-ws-image-trigger"
  description     = "Cloud Build trigger that runs on a schedule and builds the OSS Workstation Image"
  service_account = google_service_account.cloudbuild_identity.id
  location        = local.region

  source_to_build {
    ref       = "refs/heads/main"
    repo_type = "CLOUD_SOURCE_REPOSITORIES"
    uri       = local.source_repo_url
  }

  git_file_source {
    path      = "00_-_modules/workstation-image/cloudbuild.yaml"
    repo_type = "CLOUD_SOURCE_REPOSITORIES"
    revision  = "/refs/heads/main"
  }

  substitutions = {
    _IMAGE_REPOSITORY_NAME = local.workstation_registry_repository_name
    _IDE_NAME              = "oss"
    _IMAGE_TAG             = "latest"
    _WORKING_DIR           = "00_-_modules/workstation-image"
  }
}
