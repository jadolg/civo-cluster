variable "cluster_name" {
  default = "civo001"
}
variable "dns_zone_prefix" {
  default = "civo001"
}
variable "versions" {
  type    = map(string)
  default = {
    "cert-manager"          = "v1.15.3"
    "kube-prometheus-stack" = "62.3.0"
    "loki"                  = "6.10.1"
    "promtail"              = "6.16.5"
    "traefik"               = "30.1.0"
    "argocd"                = "7.5.0"
  }
}
variable "kubeconfig_file" {
  default = "./civo-kubeconfig"
}

variable "civo_region" {
  default = "FRA1"
}