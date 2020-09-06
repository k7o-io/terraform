// Scaleway - https://registry.terraform.io/providers/scaleway/scaleway/latest/docs

variable scaleway_access_key {
  type = string
}

variable scaleway_secret_key {
  type = string
}

variable scaleway_organization_id {
  type = string
}

variable scaleway_region {
  type    = string
  default = "fr-par"
}

variable scaleway_zone {
  type    = string
  default = "fr-par-1"
}

variable tags {
  type    = list(string)
  default = []
  description = "Apply tags to resources created on scaleway."
}

// Github - https://registry.terraform.io/providers/hashicorp/github/latest/docs

variable github_token {
  type = string
}

variable github_organization {
  type    = string
  default = "k7o-io"
}

// AWS - https://registry.terraform.io/providers/hashicorp/aws/latest/docs
// User must have the following permissions:
// - On the zone ID where to create records (arn:aws:route53:::hostedzone/<ZONE_ID>):
//   - route53:GetHostedZone
//   - route53:ChangeResourceRecordSets
//   - route53:ListResourceRecordSet
// - On every resource:
//   - route53:GetChange

variable aws_access_key {
  type = string
}

variable aws_secret_key {
  type = string
}

variable aws_region {
  type = string
  default = "eu-west-1"
}

variable aws_route53_zone_id {
  type = string
}

variable domain {
  type = string
  default = "k7o.io"
}