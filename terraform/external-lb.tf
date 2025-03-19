# Reserve a static external IP for the load balancer
resource "google_compute_global_address" "lb_ip" {
  provider = google.mitsui-id-net
  name     = "lb-external-ip"
}

# Health check to monitor the NGFW VM (adjust port/protocol as needed)
resource "google_compute_health_check" "ngfw_health_check" {
  provider = google.mitsui-id-net
  name     = "ngfw-health-check"

  http_health_check {
    port = 80 # Replace with your NGFW's ingress port (e.g., 443 for HTTPS)
  }
}

# Unmanaged instance group containing the NGFW VM
resource "google_compute_instance_group" "ngfw_instance_group" {
  provider  = google.mitsui-id-net
  name      = "ngfw-instance-group"
  instances = [google_compute_instance.ngfw_router.self_link]
}

# Backend service for the load balancer
resource "google_compute_backend_service" "lb_backend" {
  provider              = google.mitsui-id-net
  name                  = "lb-backend-service"
  protocol              = "HTTP" # Use "TCP" for non-HTTP traffic
  load_balancing_scheme = "EXTERNAL"
  health_checks         = [google_compute_health_check.ngfw_health_check.self_link]

  backend {
    group = google_compute_instance_group.ngfw_instance_group.self_link
  }
}

# URL map (required for HTTP/S load balancers)
resource "google_compute_url_map" "lb_url_map" {
  provider        = google.mitsui-id-net
  name            = "lb-url-map"
  default_service = google_compute_backend_service.lb_backend.self_link
}

# HTTP target proxy (for HTTP/S)
resource "google_compute_target_http_proxy" "lb_proxy" {
  provider = google.mitsui-id-net
  name     = "lb-target-proxy"
  url_map  = google_compute_url_map.lb_url_map.self_link
}

# Global forwarding rule (attach external IP and port)
resource "google_compute_global_forwarding_rule" "lb_forwarding_rule" {
  provider              = google.mitsui-id-net
  name                  = "lb-forwarding-rule"
  target                = google_compute_target_http_proxy.lb_proxy.self_link
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "80" # Listen on port 80 (use "443" for HTTPS)
  ip_address            = google_compute_global_address.lb_ip.address
}

# Firewall rule to allow health checks and LB traffic to the NGFW VM
resource "google_compute_firewall" "allow_lb_to_ngfw" {
  provider = google.mitsui-id-net
  name     = "allow-lb-to-ngfw"
  network  = google_compute_network.internet_id_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["80"] # Match the health check and LB port
  }

  # Allow traffic from Google health checkers and the LB's IP range
  source_ranges = ["35.191.0.0/16", "130.211.0.0/22", google_compute_global_address.lb_ip.address]
  target_tags   = ["nat-gateway"] # Apply to the NGFW VM
}