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

resource "null_resource" "build_and_push_image" {
  triggers = {
    cloudbuild_yaml_sha     = filesha1("${path.module}/cloudbuild.yaml")
    dockerfile_intellij_sha = filesha1("${path.module}/Dockerfile_intellij")
    dockerfile_oss_sha      = filesha1("${path.module}/Dockerfile_oss")
  }

  provisioner "local-exec" {
    working_dir = path.module
    command     = "./scripts/build_image.sh ${var.project_id} ${var.region} ${var.image_repository_name} ${var.ide_name} ${var.image_tag} ./"
  }
}