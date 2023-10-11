variable "create_project" {
  description = "Whether or not a project should be created"
  type        = string
  default     = true
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