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


resource "google_compute_network" "workstations" {
  project                 = module.project.project_id
  name                    = var.network_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "workstations" {
  project                  = module.project.project_id
  name                     = var.subnet_name
  network                  = google_compute_network.workstations.name
  ip_cidr_range            = var.subnet_cidr_range
  region                   = var.region
  private_ip_google_access = true
}

resource "google_compute_router" "default" {
  count   = var.allow_internet_access ? 1 : 0
  project = module.project.project_id
  name    = "ws-public-internet-access"
  network = google_compute_network.workstations.name
  region  = var.region

  bgp {
    asn = 64515
  }
}

resource "google_compute_router_nat" "default" {
  count                              = var.allow_internet_access ? 1 : 0
  project                            = module.project.project_id
  name                               = "ws-public-internet-access"
  nat_ip_allocate_option             = "AUTO_ONLY"
  router                             = google_compute_router.default.0.name
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  region                             = var.region

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

resource "google_compute_route" "internet_access" {
  count            = var.allow_internet_access ? 1 : 0
  project          = module.project.project_id
  dest_range       = "0.0.0.0/0"
  name             = "ws-public-internet-access"
  network          = google_compute_network.workstations.name
  next_hop_gateway = "default-internet-gateway"
}
