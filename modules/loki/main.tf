resource "kubernetes_namespace" "loki" {
  metadata {
    name   = "loki"
    labels = {
      "pod-security.kubernetes.io/enforce" = "privileged"
    }
  }
}

resource "helm_release" "loki" {
  depends_on = [
    kubernetes_namespace.loki
  ]
  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki"
  name       = "loki"
  namespace  = "loki"
  version    = var.chart_version_loki
  values     = [file("modules/loki/values-loki.yaml")]
  timeout    = 1200
}

resource "helm_release" "promtail" {
  depends_on = [
    kubernetes_namespace.loki
  ]
  repository = "https://grafana.github.io/helm-charts"
  chart      = "promtail"
  name       = "promtail"
  namespace  = "loki"
  version    = var.chart_version_promtail
  values     = [file("modules/loki/values-promtail.yaml")]
}
