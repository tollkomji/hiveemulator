# Lab 1 - IaaS manual deployment

This folder contains the prepared files for laboratory work 1: manual deployment
of Hive Emulator to an Ubuntu VPS without CI/CD.

## Target Architecture

- Hetzner Cloud VPS with Ubuntu 24.04 or 22.04.
- Student: `ІО-36 Білостенний Богдан`.
- Suggested Linux user: `kpi_io36_bilostennyi`.
- `communication-control` API runs as a `systemd` service on port `8080`.
- `hive-mind` emulator runs as a `systemd` service on port `5149`.
- Redis runs locally on the VPS on port `6379`.
- Nginx serves the map client on port `80`.
- The map client reads `/config.json` and calls:
  `http://<SERVER_IP>:8080/api/v1/client`.

## Local Preparation

Run from the repository root:

```bash
deployment/lab1/scripts/build-local.sh
```

The script creates:

- `build/lab1/communication-control-api.zip`
- `build/lab1/hive-mind-api.zip`
- `build/lab1/map-client.zip`

Before uploading, edit `build/lab1/map-client/config.json` and replace
`<SERVER_IP>` with the public VPS IP.

## VPS Bootstrap

After creating the VPS and connecting as `root`, copy the bootstrap script:

```bash
scp deployment/lab1/scripts/bootstrap-server.sh root@<SERVER_IP>:~
ssh root@<SERVER_IP>
chmod +x bootstrap-server.sh
STUDENT_USER=<STUDENT_USER> ./bootstrap-server.sh
```

The username should identify the student and group, for example:
`kpi_io36_bilostennyi`.

## Upload Artifacts

From the local machine:

```bash
scp build/lab1/communication-control-api.zip <STUDENT_USER>@<SERVER_IP>:~
scp build/lab1/hive-mind-api.zip <STUDENT_USER>@<SERVER_IP>:~
scp build/lab1/map-client.zip <STUDENT_USER>@<SERVER_IP>:~
scp deployment/lab1/scripts/install-artifacts.sh <STUDENT_USER>@<SERVER_IP>:~
```

## Install Artifacts On VPS

Connect as the student user:

```bash
ssh <STUDENT_USER>@<SERVER_IP>
chmod +x install-artifacts.sh
./install-artifacts.sh
```

## Checks For Screenshots

Run these commands for the report screenshots:

```bash
sudo ufw status verbose
systemctl status redis-server --no-pager
systemctl status communication-control --no-pager
systemctl status hive-mind --no-pager
curl http://localhost:8080/api/v1/client/area
curl http://localhost:5149/api/v1/ping
cat /var/www/hive-map/config.json
```

Open in a browser:

- `http://<SERVER_IP>/`
- `http://<SERVER_IP>:8080/swagger`
- `http://<SERVER_IP>:8080/api/v1/client/area`

## Report Evidence

For the lab report/video capture:

1. Hetzner VPS page with public IP.
2. SSH login to the VPS.
3. Created non-root user.
4. UFW firewall status.
5. Redis status.
6. API and HiveMind `systemd` services status.
7. Nginx config test and reload.
8. Browser with map opened from public VPS IP.
9. API endpoint returning latitude/longitude area data.
10. Browser developer tools showing `/config.json` and API request to VPS.
