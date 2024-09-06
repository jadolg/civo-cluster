variable "cluster_name" {}

variable "node_size" {
  default = "g4s.kube.medium"
}
variable "node_count" {
  default = 3
}
variable "kubeconfig_file" {
  default = "kubeconfig"
}