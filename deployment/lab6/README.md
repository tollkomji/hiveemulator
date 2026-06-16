# Lab 6: Monitoring

Student: ІО-36 Білостенний Богдан

This lab configures monitoring for the Hive Emulator deployment from Lab 5.

## Monitoring choice

| Option | Cost | Deployment complexity | Maintenance complexity | Fit for this project |
| --- | --- | --- | --- | --- |
| Grafana + Prometheus + Loki | Free, self-hosted | Medium | Medium | Best fit: works on one VPS, supports metrics, logs, dashboards, and alerts. |
| ELK Stack | Free, self-hosted | High | High | Powerful logs search, but too heavy for a small VPS lab deployment. |
| Zabbix | Free, self-hosted | Medium | Medium | Good infrastructure monitoring, weaker for application logs compared with Loki. |
| Azure Monitor / Cloud SaaS | Paid after free tier | Low | Low | Easy to operate, but tied to a cloud provider and less suitable for a Hetzner VPS lab. |

Chosen option: Grafana + Prometheus + Loki because it covers application availability, container metrics, VPS metrics, log collection, filtering, dashboards, and alert visibility without paid services.

## Stack

- Grafana: dashboard and log explorer, `http://188.245.181.186:3001`
- Prometheus: metrics database, `http://188.245.181.186:9090`
- Loki: log database, `http://188.245.181.186:3100`
- Promtail: Docker log collector
- Node Exporter: VPS metrics, `http://188.245.181.186:9100/metrics`
- cAdvisor: Docker container metrics, `http://188.245.181.186:8081`
- Blackbox Exporter: HTTP health checks, `http://188.245.181.186:9115`
- Alertmanager: alert visibility, `http://188.245.181.186:9093`

Grafana credentials:

```text
admin / admin
```

Anonymous viewer access is enabled for easier lab screenshots.

## Start

Lab 5 must be running first because monitoring probes the `hiveemulator-lab5` Docker network.

```bash
cd ~/hiveemulator
deployment/lab6/scripts/start.sh
```

## Stop

```bash
cd ~/hiveemulator
deployment/lab6/scripts/stop.sh
```

## Log filtering examples

Open Grafana -> Explore -> Loki.

All Lab 5 logs:

```logql
{container=~"lab5-.+"}
```

Communication Control logs:

```logql
{container="lab5-communication-control"}
```

Warnings and errors:

```logql
{container=~"lab5-.+"} |~ "warn|Warn|error|Error|fail|Fail"
```

Logs for a selected time range are filtered with the Grafana time picker in the top-right corner.

## Screenshot checklist

```bash
cd ~/hiveemulator
cat deployment/lab6/docker-compose.monitoring.yml
cat deployment/lab6/config/prometheus/prometheus.yml
cat deployment/lab6/config/promtail/config.yml
docker compose -f deployment/lab6/docker-compose.monitoring.yml ps
curl http://188.245.181.186:9090/-/ready
curl http://188.245.181.186:3100/ready
curl http://188.245.181.186:9115/probe?target=http://lab5-map-client\&module=http_2xx
```

Browser screenshots:

- Grafana dashboard: `http://188.245.181.186:3001/d/hiveemulator-monitoring/hive-emulator-monitoring`
- Grafana Explore with Loki query: `{container=~"lab5-.+"}`
- Prometheus targets: `http://188.245.181.186:9090/targets`
- Prometheus alerts: `http://188.245.181.186:9090/alerts`
- Alertmanager: `http://188.245.181.186:9093`
