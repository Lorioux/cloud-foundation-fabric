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

locals {
  # list of locations with keys
  kms_locations = distinct(flatten([
    for k, v in var.kms_keys : v.locations
  ]))
  # map { location -> { key_name -> key_details } }
  kms_locations_keys = {
    for loc in local.kms_locations :
    loc => {
      for k, v in var.kms_keys :
      k => v
      if contains(v.locations, loc)
    }
  }
  project_services = [
    "cloudkms.googleapis.com",
    "secretmanager.googleapis.com",
    "stackdriver.googleapis.com"
  ]
}
