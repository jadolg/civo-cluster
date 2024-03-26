resource "helm_release" "argocd" {
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  name             = "argocd"
  namespace        = "argocd"
  version          = var.chart_version
  create_namespace = true
  values           = [file("modules/argocd/values.yaml")]
}
