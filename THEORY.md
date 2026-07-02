# Theory Notes

## Docker Compose Port Publishing

In Docker Compose:

```yaml
ports:
  - "80:80"
```

means:

```text
host port 80 → container port 80
```

The left side is the port on the VM/host.  
The right side is the port inside the container.

## 0.0.0.0 vs 127.0.0.1

```text
127.0.0.1:80
```

means the service listens only on the local loopback interface.

```text
0.0.0.0:80
```

means the service listens on all IPv4 interfaces.

## Connection refused vs 502 Bad Gateway

### Connection refused

`Connection refused` means the client could not establish a TCP connection because nothing is listening on the target IP and port.

Typical checks:

```bash
sudo ss -ltnp | grep ':80'
docker-compose ps
```

### 502 Bad Gateway

`502 Bad Gateway` means the proxy is reachable, but it cannot get a valid response from the upstream backend.

Typical checks:

```bash
docker-compose logs --tail=50 proxy
docker-compose logs --tail=50 backend
docker-compose ps
```

## curl -v

`curl -v` shows detailed connection information:

```text
Trying 127.0.0.1:80...
Connected to 127.0.0.1
> GET /health HTTP/1.1
< HTTP/1.1 200 OK
```

It helps understand whether the problem is DNS, TCP connection, HTTP response, or application response.

## Docker DNS

Docker Compose services can reach each other by service name inside the same Compose network.

Example:

```text
proxy → backend:5000
```

The name `backend` is resolved by Docker internal DNS.

## Why not use latest image tags

Using `latest` makes deployments less predictable.  
A newer image can be pulled unexpectedly and change behavior.

Better:

```yaml
image: nginx:1.29.8
```

This improves reproducibility.

## Environment Configuration

Runtime configuration should be separated from code.

Good pattern:

```text
.env.example → committed documentation
.env         → local configuration, ignored by Git
CI env      → variables defined in GitHub Actions
```

The real `.env` file should not be committed because it may contain local configuration or secrets.

## Non-root Containers

Containers should not run applications as root unless required.

Better pattern:

```dockerfile
RUN useradd --create-home --shell /usr/sbin/nologin appuser
USER appuser
```

Reason:

```text
If the application is compromised, running as non-root reduces the potential impact.
```

## Read-only Volumes

If a container only needs to read files, mount them as read-only:

```yaml
volumes:
  - ./proxy/default.conf:/etc/nginx/conf.d/default.conf:ro
```

This reduces the risk of accidental or malicious file modification from inside the container.

## Smoke Tests

Smoke tests check whether the most important endpoints work after deployment.

Example:

```bash
./scripts/smoke-test.sh
```

This project checks:

```text
/health
/api/
/site1/
/site2/
```

## Bash Safety Flags

```bash
set -euo pipefail
```

Meaning:

```text
-e        stop on command error
-u        fail on undefined variables
pipefail  fail if any command in a pipeline fails
```

## Kubernetes Core Concepts

### Pod

A Pod is the smallest deployable unit in Kubernetes.  
It usually runs one application container.

### Deployment

A Deployment describes the desired state for Pods.

It manages:

```text
replicas
rollouts
restarts
Pod template
```

### ReplicaSet

A ReplicaSet is created by a Deployment and ensures the required number of Pods exists.

Chain:

```text
Deployment → ReplicaSet → Pod
```

### Service

A Service provides a stable network endpoint for Pods.

A `ClusterIP` Service is available only inside the Kubernetes cluster.

### Labels and Selectors

Labels mark resources:

```yaml
labels:
  app: backend
```

Selectors find matching resources:

```yaml
selector:
  app: backend
```

A Service uses selectors to send traffic to the right Pods.

### Readiness Probe

Readiness probe decides whether a Pod is ready to receive traffic.

If readiness fails:

```text
Pod may be Running but not Ready
```

### Liveness Probe

Liveness probe checks whether the container should be restarted.

If liveness fails repeatedly:

```text
Kubernetes restarts the container
```

## Minikube vs MicroK8s

MicroK8s and Minikube are both local Kubernetes environments.

In this project we use Minikube for Kubernetes practice because it is easier to keep the learning environment predictable.

Important:

```bash
minikube kubectl -- get nodes
```

or:

```bash
alias kubectl="minikube kubectl --"
```

After restart, the alias must be created again unless added to shell config.

## Building Images for Minikube

Minikube has its own Docker environment.

Before building a local image for Kubernetes:

```bash
eval $(minikube docker-env)
docker build -t backend-app:local ./backend
```

Then Kubernetes can use:

```yaml
image: backend-app:local
imagePullPolicy: Never
```

If you want to return to normal host Docker:

```bash
eval $(minikube docker-env -u)
```
