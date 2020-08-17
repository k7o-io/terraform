variable name {
  type        = string
  description = "Unique name for the subresources."
}

variable scw_access_key {
  type = string
}

variable scw_secret_key {
  type = string
}

variable scw_region {
  type    = string
  default = "fr-par"
}

variable scw_zone {
  type    = string
  default = "fr-par-2"
}

variable tags {
  type    = list(string)
  default = []
}
