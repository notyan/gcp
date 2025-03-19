resource "google_sql_database_instance" "postgres_instance" {
  provider         = google.mitsui-jp-net
  name             = "jp-cloudsql-postgres"
  region           = var.region-jp
  database_version = "POSTGRES_16"
  root_password    = "abcABC123!"

  timeouts {
    create = "10m"
    update = "10m"
    delete = "10m"
  }

  settings {
    edition           = "ENTERPRISE"
    tier              = "db-custom-1-3840"
    availability_type = "ZONAL"
    disk_type         = "PD_HDD"
    disk_size         = "100"
    ip_configuration {
      ipv4_enabled = true
    }
    location_preference {
      zone = "asia-northeast2-a"
    }
    maintenance_window {
      day  = 7
      hour = 3
    }

    backup_configuration {
      enabled = false # Disable backups to reduce costs
    }
  }
  deletion_protection = false
}


resource "google_sql_database" "om_db" {
  provider = google.mitsui-jp-net
  name     = "openmetadata"
  instance = google_sql_database_instance.postgres_instance.name
}

# Create database user
resource "random_password" "om_db_password" {
  length  = 16
  special = false
}

resource "google_sql_user" "om_db_user" {
  provider = google.mitsui-jp-net
  name     = "openmetadata-user"
  instance = google_sql_database_instance.postgres_instance.name
  password = random_password.om_db_password.result
}


output "public_ip" {
  value = google_sql_database_instance.postgres_instance.public_ip_address
}