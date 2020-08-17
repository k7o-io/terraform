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

variable tags {
  type    = list(string)
  default = []
}
