# Create private GKE cluster in Shared VPC
resource "google_container_cluster" "private_cluster" {
  provider                 = google-beta.mitsui-id-core
  name                     = "private-cluster"
  location                 = var.region-id
  remove_default_node_pool = true
  # Shared VPC configuration
  network    = google_compute_network.prod_vpc.self_link
  subnetwork = google_compute_subnetwork.subnet_prod_vpc.self_link

  # Private cluster configuration
  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = true
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }

  # Node configuration
  node_config {
    tags = ["gke-node"]

    # Customize these values as needed
    machine_type = "e2-micro"
    disk_size_gb = 40
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }


  # Master authorized networks (update with your IP ranges)
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "10.0.0.0/8"
      display_name = "temp-access"
    }
  }
  deletion_protection = false
  # Required for Terraform to remove default node pool
  initial_node_count = 1
}

# Create a separate node pool
resource "google_container_node_pool" "primary_nodes" {
  provider   = google-beta.mitsui-id-core
  name       = "primary-node-pool"
  location   = var.region-id
  cluster    = google_container_cluster.private_cluster.name
  node_count = 2

  node_config {
    tags         = ["gke-node"]
    machine_type = "e2-micro"
    disk_size_gb = 50
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

# Kubernetes provider configuration
data "google_client_config" "default" {
  provider = google-beta.mitsui-id-core
}

provider "kubernetes" {
  host                   = "https://${google_container_cluster.private_cluster.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(google_container_cluster.private_cluster.master_auth[0].cluster_ca_certificate)
}

# Expose a service with LoadBalancer
resource "kubernetes_service" "example" {
  provider = kubernetes
  metadata {
    name = "example-service"
  }
  spec {
    selector = {
      app = "example-app"
    }
    port {
      port        = 80
      target_port = 8080
    }
    type = "LoadBalancer"
  }
}