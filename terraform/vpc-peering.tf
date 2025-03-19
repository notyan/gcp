# ========================== EXTERNAL <-> TRANSIT ===============================
resource "google_compute_network_peering" "external_transit" {
  provider             = google.mitsui-id-net
  name                 = "external-transit"
  network              = google_compute_network.external_id_vpc.self_link
  peer_network         = google_compute_network.transit_id_vpc.self_link
  export_custom_routes = true
  import_custom_routes = true
}

resource "google_compute_network_peering" "transit_external" {
  provider             = google.mitsui-id-net
  name                 = "transit-external"
  network              = google_compute_network.transit_id_vpc.self_link
  peer_network         = google_compute_network.external_id_vpc.self_link
  export_custom_routes = true
  import_custom_routes = true
}
# ========================== PROD <-> TRANSIT ===============================

resource "google_compute_network_peering" "transit_prod" {
  provider             = google.mitsui-id-net
  name                 = "transit-prod"
  network              = google_compute_network.transit_id_vpc.self_link
  peer_network         = google_compute_network.prod_id_vpc.self_link
  export_custom_routes = true
  import_custom_routes = true
}

resource "google_compute_network_peering" "prod_transit" {
  provider             = google.mitsui-id-net
  name                 = "prod-transit"
  network              = google_compute_network.prod_id_vpc.self_link
  peer_network         = google_compute_network.transit_id_vpc.self_link
  export_custom_routes = true
  import_custom_routes = true
}
