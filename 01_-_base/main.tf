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

module "project" {
  source          = "../00_-_modules/project"
  create_project  = var.create_project
  project_name    = var.project_id
  parent_id       = var.parent_id
  billing_account = var.billing_account_id
  labels          = var.labels
  project_apis    = var.enable_apis ? [
    "cloudresourcemanager.googleapis.com",
    "storage.googleapis.com",
    "cloudbuild.googleapis.com",
    "compute.googleapis.com",
    "cloudscheduler.googleapis.com",
    "containerscanning.googleapis.com",
    "workstations.googleapis.com",
    "sourcerepo.googleapis.com",
    "iam.googleapis.com"
  ] : []
}

resource "random_id" "unique_identifier" {
  byte_length = 2
}

resource "google_storage_bucket" "terraform_state" {
  project                     = module.project.project_id
  location                    = var.region
  name                        = format("%s-%s", "ws-tf-state", random_id.unique_identifier.hex)
  force_destroy               = true
  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  lifecycle_rule {
    condition {
      num_newer_versions = 5
    }

    action {
      type = "Delete"
    }
  }
}

resource "local_file" "backend_config" {
  filename = "${path.module}/backend.tf"
  content  = templatefile("${path.module}/templates/backend.tf.tpl", {
    BUCKET_NAME = google_storage_bucket.terraform_state.name
    PREFIX      = "/base/tf-state/"
  })
}

resource "local_file" "workstation_base_stage_backend_config" {
  filename = "../02_-_workstation_base/backend.tf"
  content  = templatefile("${path.module}/templates/workstation_base_backend.tf.tpl", {
    BUCKET_NAME = google_storage_bucket.terraform_state.name
    PREFIX      = "/workstations/tf-state/"
    BASE_PREFIX = "/base/tf-state/"
  })
}

resource "local_file" "workstation_stage_backend_config" {
  filename = "../03_-_workstations/backend.tf"
  content  = templatefile("${path.module}/templates/workstation_backend.tf.tpl", {
    BUCKET_NAME             = google_storage_bucket.terraform_state.name
    PREFIX                  = "/workstations-resources/tf-state/"
    BASE_PREFIX             = "/base/tf-state/"
    WORKSTATION_BASE_PREFIX = "/workstations/tf-state"
  })
}


