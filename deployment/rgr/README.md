# RGR: Kubernetes deployment

Student: ІО-36 Білостенний Богдан

The RGR deploys the Hive Emulator application to a Kubernetes cluster on the VPS.

## Deployment options comparison

| Option | Cost | Complexity | Maintenance | Notes |
| --- | --- | --- | --- | --- |
| Docker Compose on VPS | Low | Low | Low | Good for Labs 4-6, but scaling and rollout controls are limited. |
| k3s on VPS | Low | Medium | Medium | Best fit for this RGR: real Kubernetes, lightweight enough for one VPS, supports Ingress and rollouts. |
| Managed Kubernetes | Higher | Medium | Low | Strong production option, but unnecessary for this university lab and more expensive. |
| Minikube on VPS | Low | Medium | Medium | Good learning tool, but k3s is closer to a real server deployment. |

Chosen option: k3s on the Hetzner VPS.

## Architecture

- Namespace: `hiveemulator-rgr`
- Redis: internal `ClusterIP` service on port `6379`
- Communication Control API: internal service on port `8080`, exposed through Ingress path `/control`
- Hive Mind: internal service on port `5149`, plus `NodePort 32149` for direct ping screenshots
- Map Client: two replicas behind a Kubernetes service, exposed through Ingress path `/`
- Ingress Controller: ingress-nginx exposed as `NodePort 32080`

Public URLs:

- Map Client: `http://188.245.181.186:32080`
- Map config: `http://188.245.181.186:32080/config.json`
- Communication Control Swagger: `http://188.245.181.186:32080/control/swagger`
- Client area API: `http://188.245.181.186:32080/control/api/v1/client/area`
- Client hive API: `http://188.245.181.186:32080/control/api/v1/client/hive`
- Hive Mind ping API: `http://188.245.181.186:32149/api/v1/ping`

## Install k3s

```bash
cd ~/hiveemulator
sudo deployment/rgr/scripts/install-k3s.sh
```

## Install ingress-nginx

```bash
cd ~/hiveemulator
deployment/rgr/scripts/install-ingress-nginx.sh
```

## Deploy application

```bash
cd ~/hiveemulator
deployment/rgr/scripts/apply.sh
```

## Status

```bash
cd ~/hiveemulator
deployment/rgr/scripts/status.sh
```

## Screenshot checklist

```bash
kubectl get nodes -o wide
kubectl get namespaces
kubectl -n hiveemulator-rgr get pods -o wide
kubectl -n hiveemulator-rgr get deployments
kubectl -n hiveemulator-rgr get svc
kubectl -n hiveemulator-rgr get ingress
kubectl -n ingress-nginx get svc
kubectl -n hiveemulator-rgr describe ingress hiveemulator
curl http://188.245.181.186:32080/config.json
curl http://188.245.181.186:32080/control/api/v1/client/area
curl http://188.245.181.186:32080/control/api/v1/client/hive
curl http://188.245.181.186:32149/api/v1/ping
```

Browser screenshots:

- `http://188.245.181.186:32080`
- `http://188.245.181.186:32080/control/swagger`
