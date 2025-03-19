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

# ============================== Elasticsearch VM ==========================
resource "google_compute_instance" "elasticsearch_vm" {
  provider     = google.mitsui-id-core
  project      = var.project-id-core
  name         = "elasticsearch-vm"
  machine_type = "e2-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  network_interface {
    network    = google_compute_network.prod_vpc.self_link
    stack_type = "IPV4_ONLY"
    subnetwork = google_compute_subnetwork.subnet_prod_vpc.self_link
  }
}