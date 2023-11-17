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

output "artifact_registry_name" {
  value = google_artifact_registry_repository.workstation_images.name
}

output "intellij_ws_image_full_name" {
  value = "${google_artifact_registry_repository.workstation_images.name}/${module.intellij_workstation_image.ide_name}-workstation:${module.intellij_workstation_image.image_tag}"
}

output "oss_ws_image_full_name" {
  value = "${google_artifact_registry_repository.workstation_images.name}/${module.oss_workstation_image.ide_name}-workstation:${module.oss_workstation_image.image_tag}"
}
