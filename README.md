
# Reverse Proxy Docker Compose Lab

![Docker Compose CI](https://github.com/Qrasann/reverse-proxy-docker-compose-lab/actions/workflows/ci.yml/badge.svg)

Devops-project: multi-container app with nginx reverse proxy, backend API, static sites, healthcheck and environment variables.


##CI/CD

Github Actions pipeline checks this project on every push:

- validates Docker Compose config
- builds Docker images
- starts all services
- checks '/api/'
- checks '/health'
- stops containers after tests

## Ansible deployment

This project includes an Ansible playbook for local deployment testing.

Run:

```bash
ansible-playbook -i ./ansible/inventory.yml ansible/deploy.yml -K
```
The playbook:

- checks Docker version
- checks Docker Compose version
- starts the Docker Compose stack
- shows running containers
- checks /api/
- checks /health

##Architecture

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
```bash
docker-compose up -d --build

CHECK
```bash
curl localhost/site1/
curl localhost/site2/
curl localhost/api/
curl localhost/health
docker-compose ps

```text
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

```
