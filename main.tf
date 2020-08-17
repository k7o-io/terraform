terraform {
  required_version = "0.13.0"
}

locals {
  tags = setunion(["terraform"], var.tags)
}

module scaleway_production {
  source         = "./scaleway"
  name           = "production"
  scw_access_key = var.scw_access_key
  scw_secret_key = var.scw_secret_key
  scw_region     = var.scw_region
  tags           = setunion(["production"], local.tags)
}

output production_kubeconfig {
  value     = module.scaleway_production.kubeconfig
  sensitive = true
}

output production_postgres_url {
  value     = module.scaleway_production.postgres_url
  sensitive = true
}
