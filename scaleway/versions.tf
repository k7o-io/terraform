terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "2.3.0"
    }
    scaleway = {
      source  = "scaleway/scaleway"
      version = "1.16.0"
    }
  }
}
