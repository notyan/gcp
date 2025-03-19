
resource "google_compute_route" "internet_routes" {
  provider          = google.mitsui-id-net
  project           = var.project-id-net
  name              = "transit-default-route"
  dest_range        = "0.0.0.0/0"
  network           = google_compute_network.transit_id_vpc.name
  next_hop_instance = google_compute_instance.ngfw_router.self_link
  priority          = 999
}