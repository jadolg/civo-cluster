resource "kubernetes_namespace" "monitoring" {
  metadata {
    name   = "monitoring"
    labels = {
      "pod-security.kubernetes.io/enforce" = "privileged"
    }
  }
}

resource "helm_release" "prometheus" {
  depends_on = [
    kubernetes_namespace.monitoring
  ]

  name = "prometheus"

  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"

  namespace = "monitoring"

  version = var.chart_version

  values = [templatefile("modules/monitoring/values.yaml", {
    slack_api_url = var.slack_api_url
  })]

  set_sensitive {
    name  = "grafana.adminPassword"
    value = var.grafana_password
  }
  set {
    name  = "prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues"
    value = false
  }
  set {
    name  = "prometheus.prometheusSpec.podMonitorSelectorNilUsesHelmValues"
    value = false
  }
  set {
    name  = "prometheus.prometheusSpec.ruleSelectorNilUsesHelmValues"
    value = false
  }
}
