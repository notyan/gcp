# ======================= FOR IN BROWSER SSH ============================
resource "google_compute_firewall" "allow_ssh_id_external" {
  provider = google.mitsui-id-net
  name     = "allow-ssh-external-id"
  network  = google_compute_network.external_id_vpc.name
  priority = 1000

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"] # Allow SSH from anywhere (for testing)
}

resource "google_compute_firewall" "allow_ssh_id_internet" {
  provider = google.mitsui-id-net
  name     = "allow-ssh-internet-id"
  network  = google_compute_network.internet_id_vpc.name
  priority = 1000

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"] # Allow SSH from anywhere (for testing)
}

resource "google_compute_firewall" "allow_ssh_id_transit" {
  provider = google.mitsui-id-net
  name     = "allow-ssh-transit-id"
  network  = google_compute_network.transit_id_vpc.name
  priority = 1000

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"] # Allow SSH from anywhere (for testing)
}

resource "google_compute_firewall" "allow_ssh_id_prod" {
  provider = google.mitsui-id-net
  name     = "allow-ssh-prod-id"
  network  = google_compute_network.prod_id_vpc.name
  priority = 1000

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"] # Allow SSH from anywhere (for testing)
}

resource "google_compute_firewall" "allow_ssh_jp_net" {
  provider = google.mitsui-jp-net
  name     = "allow-ssh-jp"
  network  = google_compute_network.external_jp_vpc.name
  priority = 1000

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"] # Allow SSH from anywhere (for testing)
}


# ======================= FOR VPC PEERING ============================
resource "google_compute_firewall" "allow_external" {
  provider = google.mitsui-id-net
  name     = "allow-external"
  network  = google_compute_network.external_id_vpc.name

  allow {
    protocol = "all"
  }

  source_ranges = ["10.10.0.0/16"]
}
resource "google_compute_firewall" "allow_transit" {
  provider = google.mitsui-id-net
  name     = "allow-transit"
  network  = google_compute_network.transit_id_vpc.id

  allow {
    protocol = "all"
  }

  source_ranges = ["10.10.0.0/16"]
}

resource "google_compute_firewall" "allow_prod" {
  provider = google.mitsui-id-net
  name     = "allow-prod"
  network  = google_compute_network.prod_id_vpc.id

  allow {
    protocol = "all"
  }

  source_ranges = ["10.10.0.0/16"]
}

# ======================= FOR CLOUD VPN PEERING ============================
resource "google_compute_firewall" "jp_vpn_traffic" {
  provider = google.mitsui-jp-net
  name     = "jp-vpn-traffic"
  network  = google_compute_network.external_jp_vpc.name

  allow {
    protocol = "udp"
    ports    = ["500", "4500"]
  }

  allow {
    protocol = "50"
  }

  source_ranges = ["0.0.0.0/0"]
  priority      = 1000
  direction     = "INGRESS"
}

resource "google_compute_firewall" "id_vpn_traffic" {
  provider = google.mitsui-id-net
  name     = "id-vpn-traffic"
  network  = google_compute_network.external_id_vpc.name

  allow {
    protocol = "udp"
    ports    = ["500", "4500"]
  }

  allow {
    protocol = "50"
  }

  source_ranges = ["0.0.0.0/0"]
  priority      = 1000
  direction     = "INGRESS"
}

resource "google_compute_firewall" "jp_allow_internal_vpn" {
  provider = google.mitsui-jp-net
  name     = "jp-allow-internal-vpn"
  network  = google_compute_network.external_jp_vpc.name

  allow {
    protocol = "all"
  }

  source_ranges = ["10.10.3.0/24"]
  priority      = 1000
  direction     = "INGRESS"
}

resource "google_compute_firewall" "id_allow_internal_vpn" {
  provider = google.mitsui-id-net
  name     = "id-allow-internal-vpn"
  network  = google_compute_network.external_id_vpc.name

  allow {
    protocol = "all"
  }

  source_ranges = ["10.10.21.0/24"]
  priority      = 1000
  direction     = "INGRESS"
}



# Allow ICMP (ping) from transit VM to GKE nodes
resource "google_compute_firewall" "allow_icmp_from_transit" {
  provider = google.mitsui-id-core
  project  = var.project-id-core
  name     = "allow-icmp-from-transit"
  network  = google_compute_network.prod_vpc.self_link

  allow {
    protocol = "icmp"
  }

  # Adjust based on your transit VM's identifiers
  source_ranges = ["10.10.0.0/16"] # Tag on your transit VM
}