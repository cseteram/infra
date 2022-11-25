# Infra

My personal infrastructure

## Prerequisites

* Terraform 1.3
* AWS Credentials
* Cloudflare API Token

## Setup

```sh
terraform init
cp .githooks/* .git/hooks/
```

## Resources

* AWS Lightsail - 2vCPU, 4GiB Memory.
* k0s - only contains a configuration file. use `k0sctl` after `terraform apply`.

In addition, some helm charts are managed by terraform.
Here is a list of them.

* Ingress NGINX Controller
* cert-manager
* OpenEBS Dynamic Local PV provisioner
* ExternalDNS
* Prometheus Operator
* Grafana
* Loki
* Argo CD
