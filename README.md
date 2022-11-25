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
* [k0sproject/k0s][k0s] - Only contains a configuration file. Use `k0sctl` after `terraform apply`.

In addition, some helm charts are managed by terraform.
Here is a list of them.

* [Ingress NGINX Controller][ingress-nginx]
* [cert-manager][cert-manager]
* [OpenEBS Dynamic Local PV provisioner][openebs-local-pv-provisioner]
* [ExternalDNS][external-dns]
* [Prometheus Operator][prometheus-operator]
* [Grafana][grafana]
* [Loki][loki]
* [Argo CD][argo-cd]

[k0s]: https://github.com/k0sproject/k0s
[ingress-nginx]: https://github.com/kubernetes/ingress-nginx
[cert-manager]: https://github.com/cert-manager/cert-manager
[openebs-local-pv-provisioner]: https://github.com/openebs/dynamic-localpv-provisioner
[external-dns]: https://github.com/kubernetes-sigs/external-dns
[prometheus-operator]: https://github.com/prometheus-operator/prometheus-operator
[grafana]: https://github.com/grafana/grafana
[loki]: https://github.com/grafana/loki
[argo-cd]: https://github.com/argoproj/argo-cd
