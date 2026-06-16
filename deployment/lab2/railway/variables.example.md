# Railway variables for Lab 2

Use one Railway project with four services:

- `Redis`
- `communication-control`
- `hive-mind`
- `map-client`

## Redis

Create a Railway Redis database from the project canvas. Railway provides these variables automatically:

- `REDISHOST`
- `REDISUSER`
- `REDISPORT`
- `REDISPASSWORD`
- `REDIS_URL`

## communication-control

```text
RAILWAY_DOCKERFILE_PATH=deployment/lab2/railway/communication-control/Dockerfile
ASPNETCORE_ENVIRONMENT=Docker
BasePath=
Redis__ConnectionString=${{Redis.REDISHOST}}:${{Redis.REDISPORT}},user=${{Redis.REDISUSER}},password=${{Redis.REDISPASSWORD}},abortConnect=False
CommunicationConfiguration__HiveMindPath=api/v1
```

Generate a public Railway domain for this service.

## hive-mind

Replace `<communication-control-public-domain>` and `<hive-mind-public-domain>` with the Railway domains generated for those services.

```text
RAILWAY_DOCKERFILE_PATH=deployment/lab2/railway/hive-mind/Dockerfile
ASPNETCORE_ENVIRONMENT=Docker
CommunicationConfiguration__RequestSchema=https
CommunicationConfiguration__CommunicationControlIP=<communication-control-public-domain>
CommunicationConfiguration__CommunicationControlPort=443
CommunicationConfiguration__CommunicationControlPath=api/v1/hive
CommunicationConfiguration__HiveIP=<hive-mind-public-domain>
CommunicationConfiguration__HivePort=443
CommunicationConfiguration__HiveID=1
```

Generate a public Railway domain for this service.

## map-client

Replace `<communication-control-public-domain>` with the Railway domain generated for `communication-control`.

```text
RAILWAY_DOCKERFILE_PATH=deployment/lab2/railway/map-client/Dockerfile
MAP_CLIENT_API_URL=https://<communication-control-public-domain>/api/v1/client
```

Generate a public Railway domain for this service. This is the URL to open in the browser for Lab 2.
