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
      version = "~> 5.72"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.44"
    }
  }
}
