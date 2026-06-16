FROM node:20-alpine AS build
WORKDIR /app

COPY src/MapClient/package*.json ./
RUN npm ci

COPY src/MapClient/ ./
RUN npm run build

FROM nginx:alpine

COPY --from=build /app/dist /usr/share/nginx/html
COPY deployment/lab2/railway/map-client/nginx.conf.template /etc/nginx/templates/default.conf.template
COPY deployment/lab2/railway/map-client/start.sh /docker-entrypoint.d/40-write-runtime-config.sh

RUN chmod +x /docker-entrypoint.d/40-write-runtime-config.sh && \
    rm -f /usr/share/nginx/html/config.json

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
