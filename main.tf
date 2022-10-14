terraform {
  cloud {
    organization = "cseteram-dev"

    workspaces {
      name = "infra"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.34"
    }

    local = {
      source  = "hashicorp/local"
      version = "~> 2.2"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.14"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.7"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.25"
    }
  }

  required_version = "~> 1.3"
}

provider "aws" {
  region = "ap-northeast-2"
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

provider "kubernetes" {
  host = format("https://%s:6443", aws_lightsail_instance.sekai.public_ip_address)

  cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
  client_certificate     = base64decode(var.client_certificate)
  client_key             = base64decode(var.client_key)
}

provider "helm" {
  kubernetes {
    host = format("https://%s:6443", aws_lightsail_instance.sekai.public_ip_address)

    cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
    client_certificate     = base64decode(var.client_certificate)
    client_key             = base64decode(var.client_key)
  }
}
