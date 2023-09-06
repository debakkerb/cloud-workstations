variable "billing_account" {
  description = "Billing account to attach to the project"
  type        = string
  default     = null
}

variable "create_project" {
  description = "Create a new project or use an existing one"
  type        = bool
  default     = true
}

variable "labels" {
  description = "Labels to assign to the project"
  type        = map(string)
  default     = {}
  nullable    = false
}

variable "parent_id" {
  description = "Parent ID.  Should include `folders/` or `organizations/`"
  type        = string
}

variable "project_name" {
  description = "Name of the project."
  type        = string
}
