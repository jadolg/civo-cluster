variable "civo_token" {}
variable "civo_region" {
  default = "FRA1"
}
variable "cluster_name" {}

variable "node_size" {
  default = "g4s.kube.medium"
}
variable "node_count" {
  default = 3
}
