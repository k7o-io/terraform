variable repository {
  type    = string
  description = "Repository where to add as a secret the CI's kubeconfig."
}

variable namespace {
  type = string
  default = ""
  description = "Namespace to create and populate with a CI service account. Defaults to repository variable."
}

variable stage {
  type = string
  description = "Stage is used as the name of the cluster (e.g. staging, production)."
}

variable cluster_host {
  type = string
  description = "Used to craft the kubeconfig for the CI service account."
}

variable cluster_ca_certificate {
  type = string
  description = "Used to craft the kubeconfig for the CI service account."
}
