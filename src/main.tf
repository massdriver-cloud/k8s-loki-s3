locals {
  loki_release     = "${var.md_metadata.name_prefix}-loki"
  promtail_release = "${var.md_metadata.name_prefix}-promtail"
  grafana_release  = "${var.md_metadata.name_prefix}-grafana"

  loki_version     = "5.5.0"
  promtail_version = "6.11.0"
  grafana_version  = "6.56.1"
}

module "application" {
  source  = "github.com/massdriver-cloud/terraform-modules//massdriver-application?ref=87cc8c2"
  name    = var.md_metadata.name_prefix
  service = "kubernetes"

  kubernetes = {
    namespace        = var.namespace
    cluster_artifact = var.kubernetes_cluster
  }
}

resource "helm_release" "loki" {
  name             = local.loki_release
  chart            = "loki"
  repository       = "https://grafana.github.io/helm-charts"
  version          = local.loki_version
  namespace        = var.namespace
  create_namespace = true

  values = [
    "${file("${path.module}/loki_values.yaml")}",
    yamlencode(local.loki_values)
  ]
}

resource "helm_release" "promtail" {
  count            = var.promtail.enabled ? 1 : 0
  name             = local.promtail_release
  chart            = "promtail"
  repository       = "https://grafana.github.io/helm-charts"
  version          = local.promtail_version
  namespace        = var.namespace
  create_namespace = true

  values = [
    "${file("${path.module}/promtail_values.yaml")}",
    yamlencode(local.promtail_values)
  ]
}

resource "helm_release" "grafana" {
  count            = var.grafana.enabled ? 1 : 0
  name             = local.grafana_release
  chart            = "grafana"
  repository       = "https://grafana.github.io/helm-charts"
  version          = local.grafana_version
  namespace        = var.namespace
  create_namespace = true

  values = [
    "${file("${path.module}/grafana_values.yaml")}",
    yamlencode(local.grafana_values)
  ]
}
