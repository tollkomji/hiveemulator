# Lab 4 - Docker Compose deployment on VPS

This folder contains the Docker Compose deployment for laboratory work 4.

Lab 3 uses Docker-only commands. Lab 4 uses `docker compose` to describe the
whole application stack as one deployment.

## Services

- `redis`: Redis cache/message storage, port `6379`.
- `communication-control`: ASP.NET Core API, port `8080`.
- `hive-mind`: HiveMind emulator, port `5149`.
- `map-client`: React/Vite UI served by Nginx, port `3000 -> 80`.

## Compose Concepts To Mention In The Report

- Network: all services join the `hiveemulator-lab4` bridge network and address
  each other by Compose service name, for example `redis` and
  `communication-control`.
- Dependencies: `communication-control` waits for a healthy Redis container;
  `hive-mind` and `map-client` depend on `communication-control`.
- Volumes: `map-client` receives runtime `config.json` through a read-only bind
  mount, so the browser calls the public VPS API URL instead of localhost.
- Ports: Compose publishes container ports to the VPS host for browser/API
  access.

## Run Locally

From the repository root:

```bash
deployment/lab4/scripts/start.sh localhost
```

Open:

- `http://localhost:3000`
- `http://localhost:8080/swagger`

## Run On VPS

If Lab 3 is running, stop it first because it uses the same public ports:

```bash
deployment/lab3/scripts/stop-containers.sh
```

Then start Lab 4:

```bash
deployment/lab4/scripts/start.sh <SERVER_IP>
```

For this VPS:

```bash
deployment/lab4/scripts/start.sh 188.245.181.186
```

Open:

- `http://188.245.181.186:3000`
- `http://188.245.181.186:8080/swagger`

Stop:

```bash
deployment/lab4/scripts/stop.sh
```

## Manual Compose Commands

The helper script runs these commands:

```bash
docker compose -f deployment/lab4/docker-compose.yml up -d --build
docker compose -f deployment/lab4/docker-compose.yml ps
```

View logs:

```bash
docker compose -f deployment/lab4/docker-compose.yml logs --tail=100 communication-control
docker compose -f deployment/lab4/docker-compose.yml logs --tail=100 hive-mind
docker compose -f deployment/lab4/docker-compose.yml logs --tail=100 map-client
```

## Checks

```bash
curl http://localhost:8080/api/v1/client/area
curl http://localhost:8080/api/v1/client/hive
curl http://localhost:5149/api/v1/ping
curl http://localhost:3000/config.json
```

External checks on VPS:

```bash
curl http://188.245.181.186:8080/api/v1/client/area
curl http://188.245.181.186:8080/api/v1/client/hive
curl http://188.245.181.186:5149/api/v1/ping
curl http://188.245.181.186:3000/config.json
```

## Report Screenshots

1. `deployment/lab4/docker-compose.yml`.
2. Generated `deployment/lab4/config/config.runtime.json`.
3. `docker compose -f deployment/lab4/docker-compose.yml up -d --build`.
4. `docker compose -f deployment/lab4/docker-compose.yml ps`.
5. `docker network inspect hiveemulator-lab4`.
6. `docker compose -f deployment/lab4/docker-compose.yml logs --tail=100 communication-control`.
7. `curl http://188.245.181.186:8080/api/v1/client/area`.
8. `curl http://188.245.181.186:8080/api/v1/client/hive`.
9. Browser with `http://188.245.181.186:3000`.
10. Swagger at `http://188.245.181.186:8080/swagger`.
