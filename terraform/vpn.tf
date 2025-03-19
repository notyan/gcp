#  ==========================  VPN STATIC IPS ==================================
resource "google_compute_address" "id_vpn_static_ip" {
  provider = google.mitsui-id-net
  name     = "id-vpn-static-ip"
  region   = var.region-id
}

resource "google_compute_address" "jp_vpn_static_ip" {
  provider = google.mitsui-jp-net
  name     = "jp-vpn-static-ip"
  region   = var.region-jp
}

#  ==========================  CLOUD VPN GATEWAYS ==================================
resource "google_compute_vpn_gateway" "id_vpn_gateway" {
  provider = google.mitsui-id-net
  name     = "id-vpn-gateway"
  network  = google_compute_network.transit_id_vpc.id
  region   = var.region-id
}

resource "google_compute_vpn_gateway" "jp_vpn_gateway" {
  provider = google.mitsui-jp-net
  name     = "jp-vpn-gateway"
  network  = google_compute_network.external_jp_vpc.id
  region   = var.region-jp
}


#  ==========================  VPN TUNNELS  ==================================
resource "google_compute_vpn_tunnel" "id_to_jp_tunnel" {
  provider                = google.mitsui-id-net
  name                    = "id-to-jp-tunnel"
  region                  = var.region-id
  target_vpn_gateway      = google_compute_vpn_gateway.id_vpn_gateway.id
  peer_ip                 = google_compute_address.jp_vpn_static_ip.address
  shared_secret           = "your-shared-secret"
  ike_version             = 2
  local_traffic_selector  = ["10.10.2.0/24"]
  remote_traffic_selector = ["10.10.21.0/24"]
  depends_on = [
    google_compute_forwarding_rule.id_esp_rule,
    google_compute_forwarding_rule.id_udp_4500_rule,
    google_compute_forwarding_rule.id_udp_500_rule
  ]
}

resource "google_compute_vpn_tunnel" "jp_to_id_tunnel" {
  provider                = google.mitsui-jp-net
  name                    = "jp-to-id-tunnel"
  region                  = var.region-jp
  target_vpn_gateway      = google_compute_vpn_gateway.jp_vpn_gateway.id
  peer_ip                 = google_compute_address.id_vpn_static_ip.address
  shared_secret           = "your-shared-secret"
  ike_version             = 2
  local_traffic_selector  = ["10.10.21.0/24"]
  remote_traffic_selector = ["10.10.2.0/24"]
  depends_on = [
    google_compute_forwarding_rule.jp_esp_rule,
    google_compute_forwarding_rule.jp_udp_4500_rule,
    google_compute_forwarding_rule.jp_udp_500_rule
  ]
}

#  ========================== VPN ROUTES ==================================
resource "google_compute_route" "id_to_jp_route" {
  provider            = google.mitsui-id-net
  name                = "id-to-jp-route"
  network             = google_compute_network.transit_id_vpc.id
  dest_range          = "10.10.21.0/24"
  next_hop_vpn_tunnel = google_compute_vpn_tunnel.id_to_jp_tunnel.id
  priority            = 1000
}

resource "google_compute_route" "jp_to_id_route" {
  provider            = google.mitsui-jp-net
  name                = "jp-to-id-route"
  network             = google_compute_network.external_jp_vpc.id
  dest_range          = "10.10.2.0/24"
  next_hop_vpn_tunnel = google_compute_vpn_tunnel.jp_to_id_tunnel.id
  priority            = 1000
}