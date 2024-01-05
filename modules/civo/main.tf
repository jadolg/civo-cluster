terraform {
  required_providers {
    civo = {
      source = "civo/civo"
    }
  }
}

provider "civo" {
  token  = var.civo_token
  region = var.civo_region
}

resource "civo_firewall" "civo_cluster" {
  name = var.cluster_name
  ingress_rule {
    action     = "allow"
    cidr       = ["0.0.0.0/0"]
    protocol   = "tcp"
    port_range = "6443"
  }
  ingress_rule {
    action     = "allow"
    cidr       = ["0.0.0.0/0"]
    protocol   = "tcp"
    port_range = "443"
  }
  ingress_rule {
    action     = "allow"
    cidr       = ["0.0.0.0/0"]
    protocol   = "tcp"
    port_range = "80"
  }
}

resource "civo_kubernetes_cluster" "civo_cluster" {
  name         = var.cluster_name
  firewall_id  = civo_firewall.civo_cluster.id
  cluster_type = "talos"
  pools {
    size       = var.node_size
    node_count = var.node_count
  }
}

output "kubeconfig" {
  value = civo_kubernetes_cluster.civo_cluster.kubeconfig
}

output "domain" {
  value = civo_kubernetes_cluster.civo_cluster.dns_entry
}
