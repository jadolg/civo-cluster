variable "civo_token" {}
variable "cluster_name" {
  default = "civo001"
}
variable "dns_zone_prefix" {
  default = "civo001"
}
variable "versions" {
  type = map(string)
  default = {
    "cert-manager"          = "v1.13.1"
    "kube-prometheus-stack" = "55.6.0"
    "loki"                  = "5.36.3"
    "promtail"              = "6.15.3"
    "traefik"               = "26.0.0"
  }
}
