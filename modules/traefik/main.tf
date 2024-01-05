resource "kubernetes_namespace" "traefik" {
  metadata {
    name = "traefik"
  }
}

resource "helm_release" "traefik" {
  depends_on = [
    kubernetes_namespace.traefik
  ]
  repository = "https://traefik.github.io/charts"
  chart      = "traefik"
  name       = "traefik"
  namespace  = "traefik"
  version    = var.chart_version
  wait       = true
}

resource "null_resource" "wait_for_lb" {
  depends_on = [helm_release.traefik]

  triggers = {
    service_name = data.kubernetes_service.traefik_lb.metadata.0.name
  }
}

data "kubernetes_service" "traefik_lb" {
  metadata {
    name      = "traefik"
    namespace = "traefik"
  }
}

output "load_balancer_hostname" {
  depends_on = [null_resource.wait_for_lb]
  value      = data.kubernetes_service.traefik_lb.status[0].load_balancer[0].ingress[0].hostname
}
