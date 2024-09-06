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
    civo = {
      source = "civo/civo"
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = var.kubeconfig_file
  }
}

provider kubernetes {
  config_path = var.kubeconfig_file
}

provider "kubectl" {
  config_path = var.kubeconfig_file
}

provider "civo" {
  token  = data.sops_file.settings.data["civo.token"]
  region = var.civo_region
}

data "sops_file" "settings" {
  source_file = "settings.sops.yaml"
}

provider "porkbun" {
  api_key    = data.sops_file.settings.data["porkbun.api_key"]
  secret_key = data.sops_file.settings.data["porkbun.secret_key"]
}
