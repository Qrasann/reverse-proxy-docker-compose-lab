# Reverse Proxy Docker Compose Lab

A DevOps practice project that demonstrates a small multi-service application with Docker Compose, Nginx reverse proxy, Ansible deployment automation, GitHub Actions CI, and reusable smoke tests.

## Architecture

```text
Client
→ Host port 80
→ Docker port publishing
→ Nginx proxy container
→ backend / site1 / site2 containers
```

## Services

- `proxy` — Nginx reverse proxy, exposed on host port `80`
- `backend` — Python backend service with `/api/` and `/health`
- `site1` — static Nginx site
- `site2` — static Nginx site

## Features

- Multi-service Docker Compose setup
- Nginx reverse proxy
- Python backend with health endpoint
- Docker healthcheck
- Pinned Nginx image version
- `.env.example` for runtime configuration
- Real `.env` ignored by Git
- Backend container runs as non-root user
- Read-only volume mounts for Nginx configuration and static content
- Reusable smoke test script
- Ansible deployment workflow
- GitHub Actions CI pipeline
- Makefile for common commands

## Requirements

- Docker
- Docker Compose
- Make
- Ansible
- Bash
- curl

## Quick Start

Create local environment file:

```bash
cp -n .env.example .env
```

Start the stack:

```bash
make up
```

Check containers:

```bash
make ps
```

Run smoke tests:

```bash
make test
```

Stop the stack:

```bash
make down
```

## Manual Docker Compose Commands

```bash
docker-compose up -d --build
docker-compose ps
./scripts/smoke-test.sh
docker-compose logs --tail=50
docker-compose down
```

## Endpoints

```text
/health → OK
/api/    → Hello from ENV
/site1/  → SITE 1
/site2/  → SITE 2
```

## Ansible

Run full deployment and endpoint checks:

```bash
ansible-playbook -i ansible/hosts ansible/site.yml -K
```

Or:

```bash
make ansible-deploy
```

The Ansible workflow:

```text
site.yml
├── deploy.yml
└── check-endpoint.yml
```

## CI/CD

GitHub Actions checks:

- Ansible syntax
- Docker Compose configuration
- Docker build
- container startup
- smoke tests

The CI workflow uses the same reusable script as local testing:

```bash
./scripts/smoke-test.sh
```

## Troubleshooting

See:

```text
RUNBOOK.md
```

## Kubernetes Practice

This project is also used as a base for Kubernetes practice.

Current Kubernetes manifests:

```text
k8s/backend-deployment.yaml
k8s/backend-service.yaml
```

The first Kubernetes step is to run only the backend as:

```text
Deployment + ClusterIP Service
```
