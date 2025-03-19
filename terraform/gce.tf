# ============================== TRANSIT VM ==========================
resource "google_compute_instance" "transit_vm" {
  provider     = google.mitsui-id-net
  project      = var.project-id-net
  name         = "transit-vm"
  machine_type = "e2-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }
  network_interface {
    network    = google_compute_network.transit_id_vpc.self_link
    stack_type = "IPV4_ONLY"
    subnetwork = google_compute_subnetwork.subnet_transit_id_vpc.self_link
  }
}

# ============================== External VM ==========================
resource "google_compute_instance" "external_vm" {
  provider     = google.mitsui-id-net
  project      = var.project-id-net
  name         = "external-vm"
  machine_type = "e2-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  network_interface {
    network    = google_compute_network.external_id_vpc.self_link
    stack_type = "IPV4_ONLY"
    subnetwork = google_compute_subnetwork.subnet_external_id_vpc.self_link
  }
}

# ============================== POSTGRES VM ==========================
resource "google_compute_instance" "postgresql_vm" {
  provider     = google.mitsui-jp-net
  project      = var.project-jp-net
  name         = "postgresql-vm"
  machine_type = "e2-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  network_interface {
    network    = google_compute_network.external_jp_vpc.self_link
    stack_type = "IPV4_ONLY"
    subnetwork = google_compute_subnetwork.subnet_external_jp_vpc.self_link
  }
}

# ============================== PRODUCTIOn VM ==========================
resource "google_compute_instance" "prod_vm" {
  provider     = google.mitsui-id-net
  project      = var.project-id-net
  name         = "prod-vm"
  machine_type = "e2-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  network_interface {
    network    = google_compute_network.prod_id_vpc.self_link
    stack_type = "IPV4_ONLY"
    subnetwork = google_compute_subnetwork.subnet_prod_id_vpc.self_link
  }
}