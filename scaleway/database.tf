output postgres_url {
  value     = "postgres://${local.db_user}:${local.db_password}@${scaleway_rdb_instance_beta.main.endpoint_ip}:${scaleway_rdb_instance_beta.main.endpoint_port}/rdb"
  sensitive = true
}

locals {
  db_user     = "admin"
  db_password = random_password.db_password.result
}

resource random_password db_password {
  length           = 128
  special          = true
  override_special = "_"
  min_upper        = 1
  min_lower        = 1
  min_numeric      = 1
  min_special      = 1
}

resource scaleway_rdb_instance_beta main {
  name           = var.name
  node_type      = "db-dev-s"
  engine         = "PostgreSQL-12"
  user_name      = local.db_user
  password       = local.db_password
  is_ha_cluster  = false
  disable_backup = true
  tags           = var.tags
}
