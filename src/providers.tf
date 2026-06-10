terraform {
  required_providers {
    mdxc = {
      source = "massdriver-cloud/mdxc"
      version = "~> 1.0"
    }

    massdriver = {
      source = "massdriver-cloud/massdriver"
      version = "~> 1.0"
    }

    helm = {
      source = "hashicorp/helm"
      version = "~> 3.0"
    }
  }
}

locals {
  kubernetes_cluster = var.kubernetes_cluster
  cloud              = local.kubernetes_cluster.specs.kubernetes.cloud
}

provider "mdxc" {
  azure = local.cloud == "azure" ? {
    client_id       = var.azure_authentication.client_id
    tenant_id       = var.azure_authentication.tenant_id
    client_secret   = var.azure_authentication.client_secret
    subscription_id = var.azure_authentication.subscription_id
  } : null

  gcp = local.cloud == "gcp" ? {
    project     = var.gcp_authentication.project_id
    credentials = jsonencode(var.gcp_authentication)
    region      = split("/", local.kubernetes_cluster.infrastructure.grn)[3]
  } : null

  aws = local.cloud == "aws" ? {
    region      = element(split(":", local.kubernetes_cluster.infrastructure.arn), 3)
    role_arn    = var.aws_authentication.arn
    external_id = var.aws_authentication.external_id
  } : null
}

provider "helm" {
  kubernetes = {
    host                   = local.kubernetes_cluster.authentication.cluster.server
    cluster_ca_certificate = base64decode(local.kubernetes_cluster.authentication.cluster.certificate-authority-data)
    token                  = local.kubernetes_cluster.authentication.user.token
  }
}
