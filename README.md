
# Reverse Proxy Docker Compose Lab

Devops-project: multi-container app with nginx reverse proxy, backend API, static sites, healthcheck and environment variables.

## Architecture

```text

Client
  |
Nginx Reverse Proxy :80
  |--- /site1/ -> site1 nginx container
  |--- /site2/ -> site2 nginx container
  |---/api/    -> backend python cointainer
  |---/health  -> backend heallth endpoint


Stack
 * Docker
 * Docker Compose
 * Nginx
 * Python HTTP server
 * Linux
 * Healthchecks
 * Environment variables
 
RUN
docker-compose up -d --build

CHECK
curl localhost/site1/
curl localhost/site2/
curl localhost/api/
curl localhost/health
docker-compose ps

expected
{"message": "Hello from ENV"}
OK

What I practiced
 * Docker images and contaainers
 * Docker Compose services
 * Reverse proxy rounting
 * Docker internal DNS
 * Volumes
 * Healthchecks
 * Restart policy
 * Environment variables
 * Debugging with logs, ps and curl

```bash
