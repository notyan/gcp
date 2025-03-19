# Add OpenMetadata Helm repository
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
