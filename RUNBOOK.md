# Runbook: Reverse Proxy Docker Compose Lab

## Overview

This project runs a small multi-service application with Docker Compose:

- `proxy` — Nginx reverse proxy, exposed on host port `80`
- `backend` — Python backend service with `/api/` and `/health`
- `site1` — static Nginx site
- `site2` — static Nginx site

Traffic flow:

```text
Client
→ host port 80
→ Docker port publishing
→ proxy container
→ backend / site1 / site2 containers
```

## Start the stack

```bash
docker-compose up -d --build
```

Or:

```bash
make up
```

## Check container status

```bash
docker-compose ps
```

Or:

```bash
make ps
```

Expected state:

```text
backend   Up (healthy)
proxy     Up
site1     Up
site2     Up
```

## Run smoke tests

```bash
./scripts/smoke-test.sh
```

Or:

```bash
make test
```

Expected result:

```text
OK: /health
OK: /api/
OK: /site1/
OK: /site2/
All smoke tests passed
```

## Check endpoints manually

```bash
curl -4 http://127.0.0.1/health
curl -4 http://127.0.0.1/api/
curl -4 http://127.0.0.1/site1/
curl -4 http://127.0.0.1/site2/
```

Expected responses:

```text
/health → OK
/api/    → Hello from ENV
/site1/  → SITE 1
/site2/  → SITE 2
```

## View logs

```bash
docker-compose logs --tail=50
docker-compose logs --tail=50 proxy
docker-compose logs --tail=50 backend
```

Or:

```bash
make logs
```

## Common issues

### Connection refused

Symptom:

```text
curl: Failed to connect to 127.0.0.1 port 80
```

Meaning:

```text
Nothing is listening on the target IP and port.
```

Check:

```bash
sudo ss -ltnp | grep ':80'
docker-compose ps
```

Fix:

```bash
docker-compose up -d
```

### 502 Bad Gateway

Meaning:

```text
The proxy is reachable, but it cannot reach the upstream backend.
```

Check:

```bash
docker-compose ps
docker-compose logs --tail=50 proxy
docker-compose logs --tail=50 backend
```

Fix:

```bash
docker-compose up -d --build
```

### 301 redirect on /api

If `/api` returns `301 Moved Permanently`, use the canonical endpoint:

```text
/api/
```

The smoke test checks `/api/` directly instead of following redirects.

### Backend is not healthy

Check health manually:

```bash
docker-compose exec backend curl -f http://localhost:5000/health
```

Check logs:

```bash
docker-compose logs --tail=50 backend
```

## Recreate the stack

Use this after volume or configuration changes if Docker Compose fails to recreate containers:

```bash
docker-compose down
docker-compose up -d --build
```

Note: `docker-compose down` removes containers and the Compose network, so it causes downtime.

## Ansible deployment

Run full deployment and smoke checks:

```bash
ansible-playbook -i ansible/hosts ansible/site.yml -K
```

Or:

```bash
make ansible-deploy
```

Expected result:

```text
failed=0
unreachable=0
```

## CI checks

GitHub Actions validates:

- Ansible syntax
- Docker Compose configuration
- Docker build
- service startup
- endpoint smoke tests via `scripts/smoke-test.sh`
