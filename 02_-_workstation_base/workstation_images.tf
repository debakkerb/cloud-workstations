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

module "intellij_workstation_image" {
  source = "../00_-_modules/workstation-image"

  project_id            = local.project_id
  region                = local.region
  image_repository_name = local.workstation_registry_repository_name
  image_tag             = "latest"
  ide_name              = "intellij"
}

module "oss_workstation_image" {
  source = "../00_-_modules/workstation-image"

  project_id            = local.project_id
  region                = local.region
  image_repository_name = local.workstation_registry_repository_name
  image_tag             = "latest"
  ide_name              = "oss"
}
