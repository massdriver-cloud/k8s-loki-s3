// Auto-generated variable declarations from massdriver.yaml
variable "aws_authentication" {
  type = object({
    data = object({
      arn         = string
      external_id = optional(string)
    })
    specs = object({
      aws = optional(object({
        region = optional(string)
      }))
    })
  })
  default = null
}
variable "azure_authentication" {
  type = object({
    data = object({
      client_id       = string
      client_secret   = string
      subscription_id = string
      tenant_id       = string
    })
    specs = object({})
  })
  default = null
}
variable "bucket" {
  type = object({
    data = object({
      infrastructure = object({
        arn = string
      })
      security = optional(object({
        iam = optional(map(object({
          policy_arn = string
        })))
        identity = optional(object({
          role_arn = optional(string)
        }))
        network = optional(map(object({
          arn      = string
          port     = number
          protocol = string
        })))
      }))
    })
    specs = object({
      aws = optional(object({
        region = optional(string)
      }))
    })
  })
}
variable "gcp_authentication" {
  type = object({
    data = object({
      auth_provider_x509_cert_url = string
      auth_uri                    = string
      client_email                = string
      client_id                   = string
      client_x509_cert_url        = string
      private_key                 = string
      private_key_id              = string
      project_id                  = string
      token_uri                   = string
      type                        = string
    })
    specs = object({
      gcp = optional(object({
        project = optional(string)
        region  = optional(string)
      }))
    })
  })
  default = null
}
variable "grafana" {
  type = object({
    enabled = bool
  })
  default = null
}
variable "kubernetes_cluster" {
  type = object({
    data = object({
      authentication = object({
        cluster = object({
          certificate-authority-data = string
          server                     = string
        })
        user = object({
          token = string
        })
      })
      infrastructure = optional(object({
        arn             = optional(string)
        oidc_issuer_url = optional(string)
        ari             = optional(string)
        grn             = optional(string)
      }))
    })
    specs = optional(object({
      aws = optional(object({
        region = optional(string)
      }))
      azure = optional(object({
        region = string
      }))
      gcp = optional(object({
        project = optional(string)
        region  = optional(string)
      }))
      kubernetes = object({
        cloud            = string
        distribution     = string
        platform_version = optional(string)
        version          = string
      })
    }))
  })
}
variable "loki" {
  type = object({
    scalable = bool
    singleBinary = optional(object({
      replicas = number
    }))
    backend = optional(object({
      replicas = number
    }))
    read = optional(object({
      replicas = number
    }))
    write = optional(object({
      replicas = number
    }))
  })
  default = null
}
variable "md_metadata" {
  type = object({
    default_tags = object({
      managed-by  = string
      md-manifest = string
      md-package  = string
      md-project  = string
      md-target   = string
    })
    deployment = object({
      id = string
    })
    name_prefix = string
    observability = object({
      alarm_webhook_url = string
    })
    package = object({
      created_at             = string
      deployment_enqueued_at = string
      previous_status        = string
      updated_at             = string
    })
    target = object({
      contact_email = string
    })
  })
}
variable "namespace" {
  type = string
}
variable "promtail" {
  type = object({
    enabled = bool
  })
  default = null
}
