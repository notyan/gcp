# NGFW / Router VM
resource "google_compute_instance" "ngfw_router" {
  provider     = google.mitsui-id-net
  project      = var.project-id-net
  name         = "ngfw-router"
  machine_type = "e2-micro"
  tags         = ["nat-gateway"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network    = google_compute_network.internet_id_vpc.self_link
    stack_type = "IPV4_ONLY"
    subnetwork = google_compute_subnetwork.subnet_internet_id_vpc.self_link
  }

  network_interface {
    network    = google_compute_network.transit_id_vpc.self_link
    stack_type = "IPV4_ONLY"
    subnetwork = google_compute_subnetwork.subnet_transit_id_vpc.self_link
  }

  # Enable IP forwarding
  can_ip_forward            = true
  allow_stopping_for_update = true
  metadata_startup_script   = file("startup-script/forwarding.sh")

}