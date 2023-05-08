locals {
  bucket_name = element(split(":", var.bucket.data.infrastructure.arn), length(split(":", var.bucket.data.infrastructure.arn)) - 1)

  loki_values = {
    singleBinary = {
      replicas = var.loki.scalable ? 0 : lookup(var.loki.singleBinary, "replicas", null)
    }
    backend = {
      replicas = var.loki.scalable ? lookup(var.loki.backend, "replicas", null) : null
    }
    write = {
      replicas = var.loki.scalable ? lookup(var.loki.write, "replicas", null) : null
    }
    read = {
      replicas = var.loki.scalable ? lookup(var.loki.read, "replicas", null) : null
    }
    serviceAccount = {
      name = var.md_metadata.name_prefix
      annotations = {
        "eks.amazonaws.com/role-arn" = module.application.id
      }
    }
    loki = {
      auth_enabled = false
      podLabels    = var.md_metadata.default_tags
      storage = {
        type = "s3"
        s3 = {
          region = var.bucket.specs.aws.region
        }
        bucketNames = {
          chunks = local.bucket_name
          ruler  = local.bucket_name
          admin  = local.bucket_name
        }
      }
    }
    test = {
      enabled = false
    }
    monitoring = {
      lokiCanary = {
        enabled = false
      }
    }
  }

  promtail_values = {
    podLabels = var.md_metadata.default_tags
    config = {
      clients = [{
        url = "http://loki-gateway.${var.namespace}.svc.cluster.local/loki/api/v1/push"
      }]
    }
  }

  grafana_values = {
    extraLabels   = var.md_metadata.default_tags
    adminPassword = module.application.secrets.grafanaAdminPassword
    datasources = {
      "loki.yaml" = {
        apiVersion : 1
        datasources : [{
          name : "Loki"
          type : "loki"
          access : "proxy"
          url : "http://loki-gateway.${var.namespace}.svc.cluster.local"
          version : 1
          isDefault : true
          jsonData : {}
        }]
      }
    }
    persistence = {
      enabled = true
      type    = "StatefulSet"
    }
    useStatefulSet = true
  }
}
