#!/bin/bash

# Copyright 2023 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

PROJECT_ID=$1
REGION=$2
IMAGE_REPOSITORY_NAME=$3
IDE_NAME=$4
IMAGE_TAG=$5
WORKING_DIR=$6

gcloud builds submit . --config cloudbuild.yaml \
  --project ${PROJECT_ID} --region ${REGION} \
  --substitutions=_IMAGE_REPOSITORY_NAME=${IMAGE_REPOSITORY_NAME},_IDE_NAME=${IDE_NAME},_IMAGE_TAG=${IMAGE_TAG},_WORKING_DIR=${WORKING_DIR}