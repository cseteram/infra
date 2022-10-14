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
