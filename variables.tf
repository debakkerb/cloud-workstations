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

variable "allow_internet_access" {
  description = "Whether or not access to the public internet is allowed"
  type        = bool
  default     = true
}

variable "create_project" {
  description = "Whether or not a project should be created"
  type        = string
  default     = true
}

variable "labels" {
  description = "Labels to attach to each resource"
  type        = map(string)
  default     = {}
}

variable "network_name" {
  description = "Name of the network"
  type        = string
  default     = "workstations"
}

variable "parent_id" {
  description = "ID of the parent.  Should be prefixed with `folders/` or `organizations/`"
  type        = string
  default     = null
}

variable "project_id" {
  description = "ID of the project where resources should be created"
  type        = string
}

variable "region" {
  description = "Region where all resources will be created"
  type        = string
  default     = "europe-west1"
}

variable "subnet_cidr_range" {
  description = "CIDR range of the subnet"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_name" {
  description = "Name of the subnet where workstations will be created."
  type        = string
  default     = "workstations"
}

variable "workstation_cluster_id" {
  description = "ID of the workstation cluster"
  type        = string
  default     = "workstation-cluster"
}

variable "workstation_cluster_config" {
  description = "Configuration to apply to the cluster"
  type        = object({
    display_name            = string
    enable_private_endpoint = bool
  })
  default = {
    display_name            = "Workstation Cluster"
    enable_private_endpoint = false
  }
}

variable "workstation_images_repository_id" {
  description = "ID of the repository where workstation images will be stored"
  type        = string
  default     = "workstation-images"
}