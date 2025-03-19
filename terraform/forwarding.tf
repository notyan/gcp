# --------------------------------
# VPN FORWARDING RULES
# --------------------------------

# Japan VPC - Forwarding rules for VPN traffic
resource "google_compute_forwarding_rule" "jp_esp_rule" {
  provider    = google.mitsui-jp-net
  name        = "fr-jp-vpn-gateway-esp"
  ip_protocol = "ESP"
  ip_address  = google_compute_address.jp_vpn_static_ip.address
  target      = google_compute_vpn_gateway.jp_vpn_gateway.id
}

resource "google_compute_forwarding_rule" "jp_udp_500_rule" {
  provider    = google.mitsui-jp-net
  name        = "fr-jp-vpn-gateway-udp500"
  ip_protocol = "UDP"
  port_range  = "500"
  ip_address  = google_compute_address.jp_vpn_static_ip.address
  target      = google_compute_vpn_gateway.jp_vpn_gateway.id
}

resource "google_compute_forwarding_rule" "jp_udp_4500_rule" {
  provider    = google.mitsui-jp-net
  name        = "fr-jp-vpn-gateway-udp4500"
  ip_protocol = "UDP"
  port_range  = "4500"
  ip_address  = google_compute_address.jp_vpn_static_ip.address
  target      = google_compute_vpn_gateway.jp_vpn_gateway.id
}

# Indonesia VPC - Forwarding rules for VPN traffic
resource "google_compute_forwarding_rule" "id_esp_rule" {
  provider    = google.mitsui-id-net
  name        = "fr-id-vpn-gateway-esp"
  ip_protocol = "ESP"
  ip_address  = google_compute_address.id_vpn_static_ip.address
  target      = google_compute_vpn_gateway.id_vpn_gateway.id
}

resource "google_compute_forwarding_rule" "id_udp_500_rule" {
  provider    = google.mitsui-id-net
  name        = "fr-id-vpn-gateway-udp500"
  ip_protocol = "UDP"
  ip_address  = google_compute_address.id_vpn_static_ip.address
  port_range  = "500"
  target      = google_compute_vpn_gateway.id_vpn_gateway.id
}

resource "google_compute_forwarding_rule" "id_udp_4500_rule" {
  provider    = google.mitsui-id-net
  name        = "fr-id-vpn-gateway-udp4500"
  ip_protocol = "UDP"
  ip_address  = google_compute_address.id_vpn_static_ip.address
  port_range  = "4500"
  target      = google_compute_vpn_gateway.id_vpn_gateway.id
}
