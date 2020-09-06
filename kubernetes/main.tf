module ci_cert_manager {
  source = "./ci"
  repository   = "cert-manager"
  stage = var.stage
  cluster_host = var.cluster_host
  cluster_ca_certificate = var.cluster_ca_certificate
}
