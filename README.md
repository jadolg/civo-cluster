# Civo cluster

A simple Kubernetes cluster deployed in [Civo cloud](https://civo.com/)

## Requirements
- OpenTofu <https://opentofu.org/>

## Modules

Versions for all helm charts are configured in the `variables.tf` file in the 
root module

### cert-manager

Used to provide SSl certificates with letsencrypt.
The configured ClusterIssuer (letsencrypt-prod) uses the 
[HTTP01 challenge](https://cert-manager.io/docs/configuration/acme/http01/).

In order to create a certificate for your ingress add the following annotation:
```yaml
  cert-manager.io/cluster-issuer: letsencrypt-prod
```

### traefik

Traefik takes care of ingresses in the cluster. The current setup will issue a
Load Balancer in Civo with extra cost.

### porkbun

porkbun is my DNS provider and what I'm doing is redirecting all 
`*.prefix.domain.com` to the Load balancer address provided by Civo.

### Metrics

The metrics module will deploy `kube-prometheus-stack` and will set 
`alertmanager` to send notifications to Slack.

### Logs (Loki+Promtail)

Login is done via Loki and Promtail. The data source is already added to the
grafana deployed by the metrics stack.

## Settings

Example settings

```yaml
grafana:
  password: .....
porkbun:
  api_key: pk1_....
  secret_key: sk1_....
  domain: example.dev
certmanager:
  email: mymail@example.com
slack:
  api_url: https://hooks.slack.com/services/.../.../...
civo:
  token: ...
```

In order to create your own cluster, edit the `.sops.yaml` file and add your
key there. Then recreate `settings.sops.yaml` with the previous format and
proceed to apply your changes.
