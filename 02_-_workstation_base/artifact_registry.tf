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

locals {
  workstation_registry_repository_name = "${local.region}-docker.pkg.dev/${local.project_id}/${google_artifact_registry_repository.workstation_images.repository_id}"
}

resource "google_artifact_registry_repository" "workstation_images" {
  project       = local.project_id
  format        = "DOCKER"
  repository_id = var.workstation_images_repository_id
  location      = local.region
}