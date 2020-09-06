terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    github = {
      source = "hashicorp/github"
    }
  }
}

locals {
  user = "ci"
  namespace = var.namespace != "" ? var.namespace : var.repository
}

resource kubernetes_namespace main {
  metadata {
    name = local.namespace
  }
}

resource kubernetes_service_account main {
  metadata {
    name      = local.user
    namespace = kubernetes_namespace.main.metadata[0].name
  }
}

resource kubernetes_role main {
  metadata {
    name      = local.user
    namespace = kubernetes_namespace.main.metadata[0].name
  }
  rule {
    api_groups = ["*"]
    resources = ["*"]
    verbs      = ["*"]
  }
}

resource kubernetes_role_binding main {
  metadata {
    name      = local.user
    namespace = kubernetes_namespace.main.metadata[0].name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.main.metadata[0].name
    namespace = kubernetes_service_account.main.metadata[0].namespace
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.main.metadata[0].name
  }
}

data kubernetes_secret token {
  metadata {
    name      = kubernetes_service_account.main.default_secret_name
    namespace = kubernetes_namespace.main.metadata[0].name
  }
}

resource github_actions_secret kubeconfig {
  repository  = var.repository
  secret_name = "${upper(var.stage)}_KUBECONFIG"
  plaintext_value = yamlencode({
    apiVersion = "v1"
    kind       = "Config"
    contexts = [{
      name = "${kubernetes_service_account.main.metadata[0].name}@${var.stage}"
      context = {
        cluster = var.stage
        namespace = kubernetes_service_account.main.metadata[0].namespace
        user    = kubernetes_service_account.main.metadata[0].name
      }
    }]
    clusters = [{
      name = var.stage
      cluster = {
        server                     = var.cluster_host
        certificate-authority-data = var.cluster_ca_certificate
      }
    }]
    users = [{
      name = kubernetes_service_account.main.metadata[0].name
      user = {
        token = data.kubernetes_secret.token.data.token
      }
    }]
  })
}
