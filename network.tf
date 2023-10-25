resource "google_compute_network" "workstations" {
  project                 = var.project_id
  name                    = var.network_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "workstations" {
  project                  = var.project_id
  name                     = var.subnet_name
  network                  = google_compute_network.workstations.name
  ip_cidr_range            = var.subnet_cidr_range
  region                   = var.region
  private_ip_google_access = true
}

resource "google_compute_router" "default" {
  count   = var.allow_internet_access ? 1 : 0
  project = var.project_id
  name    = "ws-public-internet-access"
  network = google_compute_network.workstations.name
  region  = var.region

  bgp {
    asn = 64515
  }
}

resource "google_compute_router_nat" "default" {
  count                              = var.allow_internet_access ? 1 : 0
  project                            = var.project_id
  name                               = "ws-public-internet-access"
  nat_ip_allocate_option             = "AUTO_ONLY"
  router                             = google_compute_router.default.0.name
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETS_ALL_IP_RANGES"
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