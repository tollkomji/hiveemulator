# Lab 3 - Docker container deployment

This folder contains the prepared Docker-only deployment for laboratory work 3.
It intentionally does not use `docker-compose`; compose is for laboratory work 4.

## What Is Containerized

- `communication-control`: ASP.NET Core API, port `8080`.
- `hive-mind`: ASP.NET Core HiveMind emulator, port `5149`.
- `map-client`: React/Vite static UI served by Nginx, port `3000 -> 80`.
- `redis`: Redis 7, port `6379`.

The browser opens the map client at `http://localhost:3000` locally or
`http://<SERVER_IP>:3000` on a VPS. The map client loads `/config.json` and
calls the Communication Control API.

Local API URL:

```text
http://localhost:8080/api/v1/client
```

VPS API URL:

```text
http://<SERVER_IP>:8080/api/v1/client
```

## Build Docker Images

From the repository root:

```bash
deployment/lab3/scripts/build-images.sh
```

Equivalent manual commands:

```bash
docker build -t hiveemulator/communication-control:lab3 -f src/CommunicationControl/DevOpsProject/Dockerfile src/CommunicationControl
docker build -t hiveemulator/hive-mind:lab3 -f src/CommunicationControl/DevOpsProject.HiveMind.API/Dockerfile src/CommunicationControl
docker build -t hiveemulator/map-client:lab3 -f src/MapClient/Dockerfile src/MapClient
docker pull redis:7-alpine
```

## Run Locally With Docker

```bash
deployment/lab3/scripts/run-containers.sh localhost
```

Check containers:

```bash
docker ps --filter "name=lab3-"
docker logs --tail=100 lab3-communication-control
docker logs --tail=100 lab3-hive-mind
```

Check endpoints:

```bash
curl http://localhost:8080/api/v1/client/area
curl http://localhost:8080/api/v1/client/hive
curl http://localhost:5149/api/v1/ping
```

Open in browser:

- `http://localhost:3000`
- `http://localhost:8080/swagger`

Stop:

```bash
deployment/lab3/scripts/stop-containers.sh
```

## Run On VPS With Docker

```bash
deployment/lab3/scripts/build-images.sh
deployment/lab3/scripts/run-containers.sh <SERVER_IP>
```

Open in browser:

- `http://<SERVER_IP>:3000`
- `http://<SERVER_IP>:8080/swagger`

If UFW is enabled, allow the lab ports:

```bash
sudo ufw allow 3000/tcp
sudo ufw allow 8080/tcp
sudo ufw allow 5149/tcp
```

## Report Screenshots

For the lab report/video capture:

1. Dockerfiles for API, HiveMind, and map client.
2. `docker build` commands completed successfully.
3. `docker network ls` showing `hiveemulator-lab3`.
4. `docker images` showing the built images.
5. `docker ps --filter "name=lab3-"` with all containers running.
6. `curl http://localhost:8080/api/v1/client/area`.
7. `curl http://localhost:8080/api/v1/client/hive`.
8. Browser with `http://localhost:3000` or `http://<SERVER_IP>:3000` map opened.
9. Browser developer tools showing `/config.json` and API calls.
10. Logs from `communication-control` and `hive-mind`.
