terraform {
  required_version = "0.13.2"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "2.3.0"
    }
    scaleway = {
      source  = "scaleway/scaleway"
      version = "1.17.2"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "1.13.1"
    }
    github = {
      source  = "hashicorp/github"
      version = "2.9.2"
    }
    aws = {
      source = "hashicorp/aws"
      version = "3.5.0"
    }
  }
}

provider scaleway {
  access_key      = var.scaleway_access_key
  secret_key      = var.scaleway_secret_key
  organization_id = var.scaleway_organization_id
  region          = var.scaleway_region
  zone            = var.scaleway_zone
}

module production_scaleway {
  source = "./scaleway"
  name   = "production"
  tags   = setunion(["terraform", "production"], var.tags)
}

provider github {
  token        = var.github_token
  organization = var.github_organization
}

resource github_actions_secret loadbalancer_ip {
  repository = "ambassador"
  secret_name = "PRODUCTION_LOADBALANCER_IP"
  plaintext_value = module.production_scaleway.loadbalancer_ip
}

provider aws {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region = var.aws_region
  ignore_tags {
    key_prefixes = ["kubernetes.io/"]
  }
}

resource aws_route53_record a {
  for_each = toset(["", "*."])
  zone_id = var.aws_route53_zone_id
  name = "${each.key}${var.domain}"
  type = "A"
  records = [module.production_scaleway.loadbalancer_ip]
  ttl = 600
}

provider kubernetes {
  alias                  = "production"
  load_config_file       = false
  host                   = module.production_scaleway.kubeconfig.host
  cluster_ca_certificate = base64decode(module.production_scaleway.kubeconfig.cluster_ca_certificate)
  token                  = module.production_scaleway.kubeconfig.token
}

module production_kubernetes {
  source = "./kubernetes"
  providers = {
    kubernetes = kubernetes.production
  }
  stage = "production"
  cluster_host = module.production_scaleway.kubeconfig.host
  cluster_ca_certificate = module.production_scaleway.kubeconfig.cluster_ca_certificate

}
