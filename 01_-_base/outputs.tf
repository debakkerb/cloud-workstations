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

output "admin_user" {
  description = "Admin user who gains access to the project and workstations"
  value       = var.admin_user
}

output "labels" {
  description = "Labels to add to the resource"
  value       = var.labels
}

output "network_id" {
  description = "ID of the network"
  value       = google_compute_network.workstations.id
}

output "project_id" {
  description = "ID of the project"
  value       = module.project.project_id
}

output "project_number" {
  description = "Number of the project"
  value       = module.project.project_number
}

output "region" {
  description = "Default region for all resources"
  value       = var.region
}

output "source_repo_name" {
  description = "Name of the repository"
  value       = google_sourcerepo_repository.cloud_workstation_code.name
}

output "source_repo_url" {
  description = "URL of the repository"
  value       = google_sourcerepo_repository.cloud_workstation_code.url
}

output "subnet_id" {
  description = "ID of the subnet"
  value       = google_compute_subnetwork.workstations.id
}

output "terraform_state_bucket" {
  description = "Bucket where all state is stored"
  value       = google_storage_bucket.terraform_state.name
}

output "git_repo_init_cmd" {
  value = "git remote add origin ssh://${var.admin_user}@source.developers.google.com:2022/p/${module.project.project_id}/r/${google_sourcerepo_repository.cloud_workstation_code.name}"
}