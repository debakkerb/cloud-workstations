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

variable "ide_name" {
  description = "Name of the IDE.  Should be 'intellij' or 'oss'"
  type        = string
}

variable "image_repository_name" {
  description = "Name of the Artifact Registry repository where the images will be stored"
  type        = string
}

variable "image_tag" {
  description = "Tag of the image"
  type        = string
}

variable "project_id" {
  description = "Project where the Cloud Build pipeline runs"
  type        = string
}

variable "region" {
  description = "Region where the Cloud Build pipeline will run and where the image is stored"
  type        = string
}