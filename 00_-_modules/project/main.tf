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
  parent_type  = var.create_project ? split("/", var.parent_id)[0] : ""
  parent_id    = var.create_project ? split("/", var.parent_id)[1] : ""
  project_name = var.create_project ? format("%s-%s", var.project_name, random_id.default.0.hex) : var.project_name

  project = var.create_project ? {
    project_id = google_project.default.0.project_id
    number     = google_project.default.0.number
  } : {
    project_id = data.google_project.default.0.project_id
    number     = data.google_project.default.0.number
  }
}

data "google_project" "default" {
  count      = var.create_project ? 0 : 1
  project_id = var.project_name
}

resource "google_project" "default" {
  count               = var.create_project ? 1 : 0
  project_id          = var.project_name
  name                = var.project_name
  billing_account     = var.billing_account
  folder_id           = local.parent_type == "folders" ? local.parent_id : null
  org_id              = local.parent_type == "organizations" ? local.parent_id : null
  auto_create_network = false
  labels              = var.labels
}

resource "google_project_service" "default" {
  for_each                   = var.project_apis
  project                    = local.project.project_id
  service                    = each.value
  disable_dependent_services = true
  disable_on_destroy         = true
}

resource "random_id" "default" {
  count       = var.create_project ? 1 : 0
  byte_length = 2
}
