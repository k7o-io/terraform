variable name {
  type        = string
  description = "Unique name for the subresources."
}

variable tags {
  type    = list(string)
  default = []
  description = "Tags to apply to resources."
}
