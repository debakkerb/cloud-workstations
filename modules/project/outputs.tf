output "project_id" {
  description = "ID of the project"
  value       = local.project.project_id
  depends_on  = [
    google_project_service.default
  ]
}

output "project_number" {
  description = "Number"
  value       = local.project.number

  depends_on = [
    google_project_service.default
  ]
}