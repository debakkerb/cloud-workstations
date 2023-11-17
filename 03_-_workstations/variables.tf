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

variable "create_intellij_workstation" {
  description = "Create Intellij Workstation"
  type        = bool
  default     = true
}

variable "create_oss_workstation" {
  description = "Create OSS Workstation"
  type        = bool
  default     = false
}


variable "workstation_cluster_id" {
  description = "ID of the workstation cluster"
  type        = string
  default     = "workstation-cluster"
}

variable "workstation_cluster_config" {
  description = "Configuration to apply to the cluster"
  type        = object({
    display_name = string
  })
  default = {
    display_name = "Workstation Cluster"
  }
}

variable "workstation_host_config" {
  description = "Config for each workstation"
  type        = object({
    machine_type                = string
    disable_public_ip_addresses = bool
    shielded_instance_config    = object({
      enable_secure_boot          = bool
      enable_vtpm                 = bool
      enable_integrity_monitoring = bool
    })
  })
  default = {
    machine_type                = "e2-standard-8"
    disable_public_ip_addresses = true
    shielded_instance_config    = {
      enable_secure_boot          = true
      enable_vtpm                 = true
      enable_integrity_monitoring = true
    }
  }
}

variable "workstation_directories_config" {
  description = "Configuration for persistent directories"
  type        = object({
    mount_path = string
    gce_pd     = object({
      size_gb        = number
      fs_type        = string
      disk_type      = string
      reclaim_policy = string
    })
  })
  default = {
    mount_path = "/home"
    gce_pd     = {
      size_gb        = 100
      fs_type        = "ext4"
      disk_type      = "pd-ssd"
      reclaim_policy = "DELETE"
    }
  }
}