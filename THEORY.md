# Devops Thory Notes

## Project 1: Docker Comppose Reverse Proxy Lab

### Main idea

This project shows a multi-container applicatiion where nginx as a single entry point, and backend/static services are hidden inside the Docker network.

### Key concepts

- Docker image
- Docker container
- Docker Compose seervice
- Docker network
- Reverse proxy
- Internal DNS
- Volumes
- Environment variables
- Healthcheck
- Restart policy
- CI/CD with GitHub Actions

## Important rule

if a file is copied into image using Dockerfile COPY, changes require rebuild:

```bash
docker-compose up -d --build

```

if a file mounted as volume, changes usually do not require rebuild.

Networking rule
localhost depends on where comand is executed:

 - on host: localhost means host machine
 - inside container: localhost means this container
 - between containers: use service name, for example backend:5000

502 Bad Gateway

502 usually means proxy is alive, but upstream/backend is unavailable or broken.

First checks:

docker-compose ps
docker-compose logs proxy
docker-compose logs backend
curl localhost/health

```text
