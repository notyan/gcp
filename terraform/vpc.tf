/*Mitsui id VPC and Subnet*/
resource "google_compute_network" "internet_id_vpc" {
  provider                = google.mitsui-id-net
  name                    = "internet-id-vpc"
  auto_create_subnetworks = false
  depends_on              = [google_project_service.api_id_net]
}

resource "google_compute_subnetwork" "subnet_internet_id_vpc" {
  provider      = google.mitsui-id-net
  name          = "subnet-internet-id-vpc"
  ip_cidr_range = "10.10.1.0/24"
  network       = google_compute_network.internet_id_vpc.id
  region        = var.region-id
  depends_on    = [google_project_service.api_id_net]
}

#===============================================================
resource "google_compute_network" "transit_id_vpc" {
  provider                = google.mitsui-id-net
  name                    = "transit-id-vpc"
  auto_create_subnetworks = false
  depends_on              = [google_project_service.api_id_net]
}

resource "google_compute_subnetwork" "subnet_transit_id_vpc" {
  provider      = google.mitsui-id-net
  name          = "subnet-transit-id-vpc"
  ip_cidr_range = "10.10.2.0/24"
  network       = google_compute_network.transit_id_vpc.id
  region        = var.region-id
  depends_on    = [google_project_service.api_id_net]
}

#===============================================================
resource "google_compute_network" "external_id_vpc" {
  provider                = google.mitsui-id-net
  name                    = "external-id-vpc"
  auto_create_subnetworks = false
  depends_on              = [google_project_service.api_id_net]
}

resource "google_compute_subnetwork" "subnet_external_id_vpc" {
  provider      = google.mitsui-id-net
  name          = "subnet-external-id-vpc"
  ip_cidr_range = "10.10.3.0/24"
  network       = google_compute_network.external_id_vpc.id
  region        = var.region-id
}

#===============================================================
resource "google_compute_network" "prod_id_vpc" {
  provider                = google.mitsui-id-net
  name                    = "prod-id-vpc"
  auto_create_subnetworks = false
  depends_on              = [google_project_service.api_id_net]
}

resource "google_compute_subnetwork" "subnet_prod_id_vpc" {
  provider      = google.mitsui-id-net
  name          = "subnet-prod-id-vpc"
  ip_cidr_range = "10.10.4.0/24"
  network       = google_compute_network.prod_id_vpc.id
  region        = var.region-id

  secondary_ip_range {
    range_name    = "pod-ranges"
    ip_cidr_range = "10.10.5.0/24"
  }

  secondary_ip_range {
    range_name    = "services-ranges"
    ip_cidr_range = "10.10.6.0/24"
  }

  private_ip_google_access = true
}


/*Mitsui id core VPC and Subnet*/
resource "google_compute_network" "prod_vpc" {
  provider                = google.mitsui-id-core
  name                    = "prod-vpc"
  auto_create_subnetworks = false
  depends_on              = [google_project_service.api_id_core]
}

resource "google_compute_subnetwork" "subnet_prod_vpc" {
  provider      = google.mitsui-id-core
  name          = "subnet-prod-vpc"
  ip_cidr_range = "10.10.11.0/24"
  network       = google_compute_network.prod_vpc.id
  region        = var.region-id
}

/*Mitsui jp VPC and Subnet*/
resource "google_compute_network" "external_jp_vpc" {
  provider                = google.mitsui-jp-net
  name                    = "external-jp-vpc"
  auto_create_subnetworks = false
  depends_on              = [google_project_service.api_jp_net]
}

resource "google_compute_subnetwork" "subnet_external_jp_vpc" {
  provider      = google.mitsui-jp-net
  name          = "subnet-external-jp-vpc"
  ip_cidr_range = "10.10.21.0/24"
  network       = google_compute_network.external_jp_vpc.id
  region        = var.region-jp
}
#===============================================================

# Enable Shared VPC in host project
resource "google_compute_shared_vpc_host_project" "host" {
  provider = google.mitsui-id-net
  project  = var.project-id-net
}

# Attach service project to Shared VPC
resource "google_compute_shared_vpc_service_project" "service_project" {
  provider        = google.mitsui-id-net
  host_project    = google_compute_shared_vpc_host_project.host.project
  service_project = var.project-id-core
}
