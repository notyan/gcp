provider "helm" {
  kubernetes {
    host                   = "https://${google_container_cluster.private_cluster.endpoint}"
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(google_container_cluster.private_cluster.master_auth[0].cluster_ca_certificate)
  }
}

resource "helm_release" "openmetadata" {
  name       = "openmetadata"
  repository = "https://helm.open-metadata.org/"
  chart      = "openmetadata"
  version    = "1.6.6" # Use the latest version
  namespace  = "default"


  values = [ file("helm/openmetadata.yml") ]
  

  set_sensitive {
    name  = "env.secrets.DB_PASSWORD"
    value = random_password.om_db_password.result
  }

  depends_on = [
    google_container_node_pool.primary_nodes,
    google_sql_database_instance.postgres_instance
  ]
}
