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
  project     = module.project.project_id
  account_id  = "cloud-build-custom-identity"
  description = "Identity used by Cloud Build pipelines to create Google Cloud resources"
}

resource "google_cloudbuild_trigger" "ws_intellij_trigger" {
  project         = module.project.project_id
  name            = "intellij-ws-image-trigger"
  description     = "Cloud Build trigger that runs on a schedule and builds the Intellij Workstation Image"
  service_account = google_service_account.cloudbuild_identity.id
  location        = var.region

  source_to_build {
    ref       = "refs/heads/main"
    repo_type = "CLOUD_SOURCE_REPOSITORIES"
    uri       = google_sourcerepo_repository.cloud_workstation_code.url
  }

  git_file_source {
    path      = "images/intellij/cloudbuild.yaml"
    repo_type = "CLOUD_SOURCE_REPOSITORIES"
    revision  = "/refs/heads/main"
  }

  substitutions = {
    _IMAGE_REPOSITORY_NAME = local.workstation_registry_repository_name
    _IMAGE_NAME            = "intellij-workstation"
    _IMAGE_TAG             = "latest"
    _WORKING_DIR           = "images/intellij"
  }
}