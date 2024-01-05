module "civo_cluster" {
  source       = "./modules/civo"
  civo_token   = var.civo_token
  cluster_name = var.cluster_name
}

module "cert_manager" {
  depends_on = [
    module.civo_cluster
  ]
  source        = "./modules/cert-manager"
  email         = data.sops_file.settings.data["certmanager.email"]
  chart_version = var.versions["cert-manager"]
}

module "monitoring" {
  depends_on       = [module.civo_cluster]
  source           = "./modules/monitoring"
  grafana_password = data.sops_file.settings.data["grafana.password"]
  slack_api_url    = data.sops_file.settings.data["slack.api_url"]
  chart_version    = var.versions["kube-prometheus-stack"]
}

module "loki" {
  depends_on             = [module.civo_cluster, module.monitoring]
  source                 = "./modules/loki"
  chart_version_loki     = var.versions["loki"]
  chart_version_promtail = var.versions["promtail"]
}

module "traefik" {
  depends_on = [
    module.civo_cluster
  ]
  source        = "./modules/traefik"
  chart_version = var.versions["traefik"]
}

resource "porkbun_dns_record" "cluster_cname_record" {
  depends_on = [
    module.traefik
  ]
  name    = "*.${var.dns_zone_prefix}"
  domain  = data.sops_file.settings.data["porkbun.domain"]
  content = module.traefik.load_balancer_hostname
  type    = "CNAME"
}
