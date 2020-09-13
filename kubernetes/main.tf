terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

module ci_cert_manager {
  source                 = "./ci"
  repository             = "cert-manager"
  stage                  = var.stage
  cluster_host           = var.cluster_host
  cluster_ca_certificate = var.cluster_ca_certificate
}

resource kubernetes_service_account bootstrap {
  metadata = {
    name = "bootstrap"
    namespace = "kube-system"
  }
}

resource kubernetes_cluster_role_binding bootstrap {
  metadata = {
    name = "bootstrap"
  }
  role_ref = {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "view"
  }
  subject = {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.bootstrap.metadata[0].name
    namespace = kubernetes_service_account.bootstrap.metadata[0].namespace
  }
}

resource kubernetes_job bootstrap {
  depends_on = [
    kubernetes_cluster_role_binding.bootstrap
  ]
  wait_for_completion = true
  timeouts = {
    create = "10m"
  }
  metadata = {
    name      = "bootstrap"
    namespace = kubernetes_service_account.bootstrap.metadata[0].namespace
  }
  spec = {
    template = {
      spec = {
        service_account_name    = kubernetes_service_account.bootstrap.metadata[0].name
        active_deadline_seconds = 600
        security_context = {
          run_as_non_root = true
        }
        container = {
          name  = "bootstrap"
          image = "docker.pkg.github.com/k7o-io/bootstrap/bootstrap"
          security_context = {
            allow_privilege_escalation = false
            capabilities = {
              drop = ["all"]
            }
            privileged         = false
            readOnlyFilesystem = true
          }
        }
        restart_policy = "Never"
      }
    }
    backoff_limit = 2
  }
}
