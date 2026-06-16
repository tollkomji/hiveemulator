# Lab 2: PaaS deployment with Railway

Student: ІО-36 Білостенний Богдан

This lab prepares the Hive Emulator project for deployment with the PaaS approach using Railway.

## Lab requirement

The lab requires:

1. Deploying the application using the PaaS approach.
2. Comparing PaaS deployment with IaaS deployment.
3. Optional autoscaling.
4. A report with a deployment diagram, screenshots, and conclusion.

## Why Railway

Railway is suitable for this lab because it can deploy GitHub repositories, provide managed Redis, build services from Dockerfiles, inject environment variables, provide public HTTPS domains, and show deployment logs/metrics in the dashboard.

## Architecture

```text
Browser
  |
  v
map-client Railway service
  |
  v
communication-control Railway service
  |
  +--> Redis Railway database
  |
  v
hive-mind Railway service
```

Railway project services:

- `Redis`: managed Redis database.
- `communication-control`: .NET API.
- `hive-mind`: .NET Hive emulator API.
- `map-client`: React/Vite static frontend served by nginx.

## Railway setup

1. Create a new Railway project.
2. Add a Redis database.
3. Add a GitHub service from this repository for `communication-control`.
4. Add a GitHub service from this repository for `hive-mind`.
5. Add a GitHub service from this repository for `map-client`.
6. For each service, set variables from `deployment/lab2/railway/variables.example.md`.
7. Generate public domains for:
   - `communication-control`
   - `hive-mind`
   - `map-client`
8. Redeploy all three application services after domain variables are configured.

## Dockerfiles

Railway is configured through `RAILWAY_DOCKERFILE_PATH`:

| Service | Dockerfile |
| --- | --- |
| `communication-control` | `deployment/lab2/railway/communication-control/Dockerfile` |
| `hive-mind` | `deployment/lab2/railway/hive-mind/Dockerfile` |
| `map-client` | `deployment/lab2/railway/map-client/Dockerfile` |

These Dockerfiles are separate from Labs 3-6 because Railway injects a dynamic `PORT` variable and the frontend needs runtime `config.json` generation.

## PaaS vs IaaS comparison

| Criterion | IaaS VPS | PaaS Railway |
| --- | --- | --- |
| Server setup | Manual OS, firewall, runtime installation | Platform manages runtime environment |
| Deployment | Manual scripts, SSH, Docker, system services | GitHub integration and service deployments |
| Scaling | Manual VPS resize or extra servers | Can be adjusted per service in the platform |
| Logs | Need SSH, Docker logs, or custom monitoring | Built-in deployment logs and service logs |
| Control | Maximum control over OS and network | Less OS-level control, simpler operations |
| Best use | Custom infrastructure and full control | Fast application deployment and lab demo |

## Screenshot checklist

Railway UI:

1. Project canvas with `Redis`, `communication-control`, `hive-mind`, and `map-client`.
2. Variables for each service.
3. Build/deploy logs for each application service.
4. Public domains.
5. Service metrics/logs.

Browser/API:

```bash
curl https://<map-client-public-domain>/config.json
curl https://<communication-control-public-domain>/api/v1/client/area
curl https://<communication-control-public-domain>/api/v1/client/hive
curl https://<hive-mind-public-domain>/api/v1/ping
```

Open in browser:

```text
https://<map-client-public-domain>
https://<communication-control-public-domain>/swagger
```

## References

- Railway Dockerfiles: https://docs.railway.com/builds/dockerfiles
- Railway monorepo deployments: https://docs.railway.com/deployments/monorepo
- Railway Redis: https://docs.railway.com/databases/redis
- Railway private networking: https://docs.railway.com/networking/private-networking
