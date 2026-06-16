# Lab 5: GitHub CI/CD deployment

Student: ІО-36 Білостенний Богдан

This lab prepares a GitHub Actions CI/CD pipeline for the Hive Emulator project. The pipeline validates the source code, builds Docker images, pushes them to GitHub Container Registry, and deploys the selected branch to a VPS over SSH.

## Pipeline flow

1. `build` checks the .NET solution and the Map Client frontend.
2. `docker` builds and pushes three images to GHCR:
   - `communication-control`
   - `hive-mind`
   - `map-client`
3. `deploy` connects to the VPS, pulls the selected Git branch, logs in to GHCR, pulls the pushed images, and starts the stack with Docker Compose.
4. `CodeQL` runs a SAST scan for C# and JavaScript/TypeScript.

## GitHub secrets

Configure these secrets in GitHub repository settings:

| Secret | Purpose |
| --- | --- |
| `GHCR_USERNAME` | GitHub username used to pull private GHCR packages on the VPS. |
| `GHCR_READ_TOKEN` | GitHub token with `read:packages` permission. |
| `DEV_VPS_HOST` | Development VPS IP or host. |
| `DEV_VPS_USER` | Development VPS SSH user. |
| `DEV_VPS_SSH_KEY` | Private SSH key for the development VPS. |
| `PROD_VPS_HOST` | Production VPS IP or host. |
| `PROD_VPS_USER` | Production VPS SSH user. |
| `PROD_VPS_SSH_KEY` | Private SSH key for the production VPS. |

If there is only one VPS for the lab, set both DEV and PROD secrets to the same server values.

## Branch mapping

| Branch | Environment |
| --- | --- |
| `dev` | `development` |
| `main` | `production` |

Manual deployment is available through `Actions -> CI/CD -> Run workflow`.

## VPS runtime

The deployment uses `deployment/lab5/docker-compose.deploy.yml`. Unlike Lab 4, it does not build images on the VPS. It only pulls images from GHCR and starts the containers.

Public endpoints after deployment:

- Map Client: `http://188.245.181.186:3000`
- Communication Control Swagger: `http://188.245.181.186:8080/swagger`
- Client area API: `http://188.245.181.186:8080/api/v1/client/area`
- Client hive API: `http://188.245.181.186:8080/api/v1/client/hive`
- Hive Mind ping API: `http://188.245.181.186:5149/api/v1/ping`

## Useful screenshot commands

```bash
cd ~/hiveemulator
cat .github/workflows/ci.yml
cat .github/workflows/codeql.yml
cat deployment/lab5/docker-compose.deploy.yml
docker compose --env-file deployment/lab5/.env.runtime -f deployment/lab5/docker-compose.deploy.yml ps
docker images | grep hiveemulator
curl http://188.245.181.186:3000/config.json
curl http://188.245.181.186:8080/api/v1/client/area
curl http://188.245.181.186:8080/api/v1/client/hive
curl http://188.245.181.186:5149/api/v1/ping
```
