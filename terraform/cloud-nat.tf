# Cloud NAT for internet-id-vpc (enables egress to internet)
resource "google_compute_router" "nat_router" {
  provider    = google.mitsui-id-net
  project     = var.project-id-net
  name        = "nat-router"
  network     = google_compute_network.internet_id_vpc.id
  region      = var.region-id
  description = "Router for Cloud NAT service"
}

resource "google_compute_router_nat" "nat_config" {
  provider                           = google.mitsui-id-net
  project                            = var.project-id-net
  name                               = "egress-nat"
  router                             = google_compute_router.nat_router.name
  region                             = var.region-id
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}