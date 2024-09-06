terraform {
  required_providers {
    civo = {
      source = "civo/civo"
    }
  }
}

resource "civo_firewall" "civo_cluster" {
  name = var.cluster_name
  create_default_rules = false
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
  egress_rule {
    label      = "all"
    protocol   = "tcp"
    port_range = "1-65535"
    cidr       = ["0.0.0.0/0"]
    action     = "allow"
  }
}

resource "civo_kubernetes_cluster" "civo_cluster" {
  name         = var.cluster_name
  firewall_id  = civo_firewall.civo_cluster.id
  write_kubeconfig = true
  cluster_type = "talos"
  pools {
    size       = var.node_size
    node_count = var.node_count
  }
}

resource "local_file" "kubeconfig" {
  content  = civo_kubernetes_cluster.civo_cluster.kubeconfig
  filename = var.kubeconfig_file
}

output "domain" {
  value = civo_kubernetes_cluster.civo_cluster.dns_entry
}
