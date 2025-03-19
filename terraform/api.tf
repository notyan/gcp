resource "google_project_service" "api_id_net" {
  for_each = toset([
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com"
  ])
  provider = google.mitsui-id-net
  project  = var.project-id-net
  service  = each.value

  disable_on_destroy = false
}


resource "google_project_service" "api_id_core" {
  for_each = toset([
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com"
  ])
  provider = google.mitsui-id-core
  project  = var.project-id-core
  service  = each.value

  disable_on_destroy = false
}

resource "google_project_service" "api_jp_net" {
  for_each = toset([
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com"
  ])
  provider = google.mitsui-jp-net
  project  = var.project-jp-net
  service  = each.value

  disable_on_destroy = false
}
