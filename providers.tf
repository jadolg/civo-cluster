terraform {
  required_providers {
    kubectl = {
      source = "gavinbunney/kubectl"
    }
    sops = {
      source  = "carlpett/sops"
      version = "~> 0.5"
    }
    porkbun = {
      source = "cullenmcdermott/porkbun"
    }
  }
}

locals {
  kubeconfig-file-name = "civo-kubeconfig"
}

resource "null_resource" "write_kubeconfig" {
  depends_on = [module.civo_cluster]

  provisioner "local-exec" {
    command = "echo '${module.civo_cluster.kubeconfig}' > ${local.kubeconfig-file-name}"
  }
}

resource "local_file" "kubeconfig" {
  content  = module.civo_cluster.kubeconfig
  filename = local.kubeconfig-file-name
}

provider "helm" {
  kubernetes {
    config_path = local_file.kubeconfig.filename
  }
}

provider kubernetes {
  config_path = local_file.kubeconfig.filename
}

provider "kubectl" {
  config_path = local_file.kubeconfig.filename
}

data "sops_file" "settings" {
  source_file = "settings.sops.yaml"
}

provider "porkbun" {
  api_key = data.sops_file.settings.data["porkbun.api_key"]
  secret_key = data.sops_file.settings.data["porkbun.secret_key"]
}
