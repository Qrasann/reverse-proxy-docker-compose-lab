# Kubernetes Practice

This directory contains Kubernetes manifests for running parts of the project in a local Kubernetes cluster.

Current target:

```text
backend → Deployment + ClusterIP Service
```

## Start Minikube

```bash
sudo microk8s stop 2>/dev/null || true

minikube start --driver=docker --cpus=2 --memory=4096
alias kubectl="minikube kubectl --"

kubectl get nodes
```

## Build backend image inside Minikube

```bash
eval $(minikube docker-env)
docker build -t backend-app:local ./backend
docker images | grep backend-app
```

## Apply manifests

```bash
kubectl delete deployment backend --ignore-not-found
kubectl delete service backend --ignore-not-found

kubectl apply -f k8s/backend-deployment.yaml
kubectl apply -f k8s/backend-service.yaml
```

## Check resources

```bash
kubectl get deployments
kubectl get pods
kubectl get svc
```

Expected result:

```text
deployment/backend   READY 1/1
pod/backend-...      1/1 Running
service/backend      ClusterIP 5000/TCP
```

## Test with port-forward

```bash
kubectl port-forward svc/backend 5000:5000
```

In another terminal:

```bash
curl http://127.0.0.1:5000/health
curl http://127.0.0.1:5000/api/
```

Expected:

```text
OK
Hello from Kubernetes
```

## Troubleshooting

### kubectl points to MicroK8s instead of Minikube

Use:

```bash
minikube kubectl -- get nodes
```

Or set alias:

```bash
alias kubectl="minikube kubectl --"
```

### Pod has ErrImageNeverPull

The image was not built inside Minikube Docker.

Fix:

```bash
eval $(minikube docker-env)
docker build -t backend-app:local ./backend
kubectl rollout restart deployment backend
```

### Deployment exists but Pod does not appear

Check the chain:

```bash
kubectl get deployment backend
kubectl get rs
kubectl get pods
kubectl describe deployment backend
kubectl get events --sort-by=.lastTimestamp
```

Expected chain:

```text
Deployment → ReplicaSet → Pod
```
