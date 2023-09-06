locals {
  parent_type  = split("/", var.parent_id)[0]
  parent_id    = split("/", var.parent_id)[1]
  project_name = var.create_project ? format("%s-%s", var.project_name, random_id.default.0.hex) : var.project_name
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

resource "random_id" "default" {
  count       = var.create_project ? 1 : 0
  byte_length = 2
}
