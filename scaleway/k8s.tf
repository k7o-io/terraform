output kubeconfig {
  value     = scaleway_k8s_cluster_beta.main.kubeconfig[0]
  sensitive = true
  depends_on = [
    # Cluster requires a pool to be functional or is unreachable otherwise.
    scaleway_k8s_pool_beta.default
  ]
}

output loadbalancer_ip {
  value = scaleway_lb_ip_beta.ip.ip_address
}

resource scaleway_k8s_cluster_beta main {
  name    = var.name
  version = "1.19"
  cni     = "calico"
  tags    = var.tags
  auto_upgrade {
    enable                        = true
    maintenance_window_start_hour = 0
    maintenance_window_day        = "any"
  }
}

resource scaleway_instance_placement_group default {}

resource scaleway_k8s_pool_beta default {
  cluster_id          = scaleway_k8s_cluster_beta.main.id
  name                = "${var.name}-default"
  node_type           = "dev1-m"
  size                = 1
  tags                = var.tags
  placement_group_id  = scaleway_instance_placement_group.default.id
  autohealing         = true
  wait_for_pool_ready = true
}

resource scaleway_lb_ip_beta ip {}
