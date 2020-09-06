variable stage {
  type = string
  description = "Stage is used as the name of the cluster (e.g. staging, production)"
}

variable cluster_host {
  type = string
  description = "Used to craft the kubeconfig for the CI service accounts"
}

variable cluster_ca_certificate {
  type = string
  description = "Used to craft the kubeconfig for the CI service accounts"
}
