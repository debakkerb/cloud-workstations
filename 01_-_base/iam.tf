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

resource "google_project_iam_member" "admin_user_permissions" {
  for_each = toset([
    "roles/source.admin",
    "roles/cloudscheduler.admin",
    "roles/workstations.admin",
    "roles/storage.admin",
    "roles/compute.admin",
    "roles/artifactregistry.admin",
    "roles/cloudbuild.builds.editor",
    "roles/browser" // Needed for JetBrains Gateway, otherwise it's impossible to browse available Workstations
  ])
  project = module.project.project_id
  member  = "user:${var.admin_user}"
  role    = each.value
}
