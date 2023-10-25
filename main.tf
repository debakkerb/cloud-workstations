module "project" {
  source         = "./modules/project"
  create_project = var.create_project
  project_name   = var.project_id
  parent_id      = var.parent_id
  labels         = var.labels
}

