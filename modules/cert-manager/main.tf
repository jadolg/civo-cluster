terraform {
  required_providers {
    kubectl = {
      source = "gavinbunney/kubectl"
    }
  }
}

resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = "cert-manager"
  }
}

resource "helm_release" "cert-manager" {
  depends_on = [kubernetes_namespace.cert_manager]
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  name       = "cert-manager"
  namespace  = "cert-manager"
  version    = var.chart_version

  set {
    name  = "installCRDs"
    value = true
  }

  wait_for_jobs = true
}

resource "kubectl_manifest" "clusterissuer" {
  depends_on = [helm_release.cert-manager]
  yaml_body  = templatefile("modules/cert-manager/clusterissuer.yaml", {
    email = var.email
  })
  wait_for_rollout = true
}
