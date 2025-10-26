# MLOps Assignment #2 — DevOps & MLOps Implementation Guide

This document is a submission-ready step-by-step guide for Part 2 (DevOps & MLOps) of the assignment. It both documents the work and gives precise commands you can run. All screenshots are marked with placeholders — replace them with the actual images you take.

---

## Summary / Objective

Containerize and deploy the AutoMERNate microservices stack (frontend, API Gateway, services) using Docker, Docker Compose, and Kubernetes (Minikube). Document the process with exact screenshot placeholders so you can submit this file along with images.

Target services and ports (local development):
- Frontend: http://localhost:3000
- API Gateway: http://localhost:5000
- Product Service: http://localhost:5001
- User Service: http://localhost:5002
- Order Service: http://localhost:5003
- Payment Service: http://localhost:5004
- Notification Service: http://localhost:5005

---

## Prerequisites

On your machine (Windows), install:
- Docker Desktop (with WSL2 or Hyper-V) or Docker Engine + Compose
- Node.js and npm (already installed as per project)
- kubectl
- minikube
- (Optional) A Docker Hub or other container registry account

Verify installations:

```powershell
node -v
npm -v
docker --version
docker compose version
kubectl version --client --short
minikube version
```

Take Screenshot: `[Screenshot 00 – Environment check: node, docker, kubectl, minikube]`

---

## Phase 1 — Dockerization (per-service)

Goal: Create or verify Dockerfiles for each service and explain each Dockerfile line-by-line. For this project, each service folder should contain a Dockerfile. The frontend uses a multi-stage build; backend services use Node base image.

How to present: For each service create a short subsection with:
1. Dockerfile content
2. Explanation (line-by-line)
3. Commands to build and tag the image
4. Screenshot placeholder where requested

Example: Backend service (User Service) Dockerfile

```
# User Service Dockerfile (example)
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --silent
COPY . .
EXPOSE 5002
CMD ["node", "server.js"]
```

Explanation (line-by-line):
- `FROM node:18-alpine` — Small Node.js base image.
- `WORKDIR /app` — Sets working directory inside container.
- `COPY package*.json ./` and `RUN npm ci` — Copies dependency manifest and installs dependencies early to leverage Docker layer cache.
- `COPY . .` — Copies the rest of the source code.
- `EXPOSE 5002` — Documents port; not required to open it from host.
- `CMD ["node","server.js"]` — Default command to run.

Build and tag (example):

```powershell
cd services\user-service
docker build -t automernate-user:dev .
```

Take Screenshot: `[Screenshot 01 – Dockerfile of Backend Service (user-service)]`
Take Screenshot: `[Screenshot 02 – docker build output for user-service]`

Repeat the above for each service. Key files to capture:
- `frontend/Dockerfile` (multi-stage) — `[Screenshot 03 – Frontend Dockerfile (multi-stage)]`
- `services/api-gateway/Dockerfile` — `[Screenshot 04 – API Gateway Dockerfile]`
- Each microservice Dockerfile — `[Screenshot 05 – Dockerfiles of microservices]`

After building several images, capture the image list:

```powershell
docker images | findstr automernate
```

Take Screenshot: `[Screenshot 06 – docker images list showing built images]`


---

## Phase 1 — Quick checklist

- [ ] Dockerfile present for each service
- [ ] Images built locally for each service
- [ ] Tag images clearly: `automerate-<service>:dev`


---

## Phase 2 — Docker Compose

Goal: Compose the services and run them locally with one command.

Create `docker-compose.yml` at repository root with services:
- frontend
- api-gateway
- product-service
- user-service
- order-service
- payment-service
- notification-service
- (Optional) a local MongoDB (or point to your existing Atlas)

Example (skeleton):

```yaml
version: '3.8'
services:
  frontend:
    image: automernate-frontend:dev
    build: ./frontend
    ports:
      - '3000:80'
    depends_on:
      - api-gateway

  api-gateway:
    image: automernate-api-gateway:dev
    build: ./services/api-gateway
    ports:
      - '5000:5000'
    depends_on:
      - product-service
      - user-service
      - order-service
      - payment-service
      - notification-service

  user-service:
    image: automernate-user:dev
    build: ./services/user-service
    ports:
      - '5002:5002'
    environment:
      - MONGO_URI=<your-mongo-uri>
      - JWT_SECRET=your-secret

  # ...other services similarly

networks:
  default:
    driver: bridge
```

Notes:
- Use environment variables or a `.env` file to hold secrets. Docker Compose will pick up `.env` in the same directory.
- For local testing, it's okay to map ports so you can reach each service directly.

Commands:

```powershell
docker compose up --build -d
# Wait a few seconds
docker compose ps
```

Take Screenshot: `[Screenshot 07 – docker-compose.yml file structure]`
Take Screenshot: `[Screenshot 08 – docker compose up output showing services starting]`
Take Screenshot: `[Screenshot 09 – docker ps showing all containers running]`
Take Screenshot: `[Screenshot 10 – Browser screenshot of frontend UI loaded via localhost:3000]`


---

## Phase 3 — Kubernetes (Minikube)

Goal: Move from Docker Compose to Kubernetes using Minikube for local cluster testing.

### 3.0 — Start Minikube

```powershell
minikube start --driver=hyperv --cpus=4 --memory=4096
```

Take Screenshot: `[Screenshot 11 – minikube start output]`

Show minikube status and kubectl versions:

```powershell
minikube status
kubectl version --client --short
```

Take Screenshot: `[Screenshot 12 – kubectl version and minikube status]`


### 3.1 — Namespace and context

Create a namespace for the assignment to keep resources isolated:

```powershell
kubectl create namespace automernate
kubectl config set-context --current --namespace=automerate
```

Take Screenshot: `[Screenshot 13 – kubectl get namespaces showing automernate]`


### 3.2 — Manifests to write

For each service write the following manifests:
- `deployment-<service>.yaml` — Deployment (3 replicas)
- `service-<service>.yaml` — Service (ClusterIP or NodePort)
- `configmap-<service>.yaml` — Non-sensitive config
- `secret-<service>.yaml` — Sensitive values (JWT secrets, DB URIs)

Example Deployment (user-service):

```yaml
# deployment-user.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: user-service
  labels:
    app: user-service
spec:
  replicas: 3
  selector:
    matchLabels:
      app: user-service
  template:
    metadata:
      labels:
        app: user-service
    spec:
      containers:
        - name: user-service
          image: automernate-user:dev
          ports:
            - containerPort: 5002
          envFrom:
            - secretRef:
                name: user-service-secrets
            - configMapRef:
                name: user-service-config
          readinessProbe:
            httpGet:
              path: /health
              port: 5002
            initialDelaySeconds: 5
            periodSeconds: 10
```

Example Service (NodePort for external access):

```yaml
# service-user.yaml
apiVersion: v1
kind: Service
metadata:
  name: user-service
spec:
  type: NodePort
  selector:
    app: user-service
  ports:
    - port: 5002
      targetPort: 5002
      nodePort: 30062
```

Take Screenshot: `[Screenshot 14 – example deployment manifest open in editor]`

Apply manifests:

```powershell
kubectl apply -f k8s/manifests/ -R
```

Take Screenshot: `[Screenshot 15 – kubectl apply output for all manifests]`

Verify pods and services:

```powershell
kubectl get pods -n automernate
kubectl get svc -n automernate
```

Take Screenshot: `[Screenshot 16 – kubectl get pods showing all services running]`
Take Screenshot: `[Screenshot 17 – kubectl get svc showing NodePort/ClusterIP mappings]`


### 3.3 — Accessing the frontend

If you used NodePort you can use the Minikube IP:

```powershell
$IP = minikube ip
# If frontend NodePort is 30080
# Open in browser: http://$IP:30080
```

Or enable Ingress and use an Ingress resource:

```powershell
minikube addons enable ingress
# create ingress manifest
kubectl apply -f k8s/ingress.yaml
```

Take Screenshot: `[Screenshot 18 – Browser screenshot showing frontend served from Minikube IP]`


---

## Phase 4 — Scaling and Validation

Scale a deployment:

```powershell
kubectl scale deployment user-service --replicas=6
kubectl get pods -l app=user-service
```

Take Screenshot: `[Screenshot 19 – kubectl scale command output]`
Take Screenshot: `[Screenshot 20 – kubectl get pods showing scaled replicas]`

Check rollout status:

```powershell
kubectl rollout status deployment/user-service
```

Take Screenshot: `[Screenshot 21 – kubectl rollout status user-service]`


---

## Phase 5 — Monitoring and Debugging

Use the following commands to inspect services and solve problems:

- `kubectl logs <pod-name>` — show logs
- `kubectl describe pod <pod-name>` — show events and state
- `kubectl get events -n automernate` — cluster events
- `minikube dashboard` — launch Kubernetes dashboard in browser

Take Screenshot: `[Screenshot 22 – kubectl logs <pod-name> showing successful requests]`
Take Screenshot: `[Screenshot 23 – minikube dashboard overview]`


---

## Phase 6 — Final Documentation and Submission

In your final document (Word or Markdown), use the placeholder names below. Replace each placeholder with the actual image file you collect.

Suggested filenames and placeholders:
- fig01_api_gateway_dockerfile.png — `[Screenshot 01 – API Gateway Dockerfile]`
- fig02_frontend_multistage_dockerfile.png — `[Screenshot 03 – Frontend Dockerfile]`
- fig03_user_docker_build.png — `[Screenshot 02 – docker build output for user-service]`
- fig04_docker_images.png — `[Screenshot 06 – docker images list]`
- fig05_docker_compose_up.png — `[Screenshot 08 – docker compose up output]`
- fig06_docker_ps.png — `[Screenshot 09 – docker ps showing containers running]`
- fig07_frontend_local.png — `[Screenshot 10 – Browser screenshot of frontend UI]`
- fig08_minikube_start.png — `[Screenshot 11 – minikube start output]`
- fig09_kubectl_pods.png — `[Screenshot 16 – kubectl get pods]`
- fig10_kubectl_services.png — `[Screenshot 17 – kubectl get svc]`
- fig11_kubectl_logs.png — `[Screenshot 22 – kubectl logs]`

When writing captions in the submission, use:

> Figure 01 — Dockerfile for API Gateway. (Replace this placeholder with `fig01_api_gateway_dockerfile.png`.)


---

## Troubleshooting Tips (common issues)

1. Docker build fails due to missing dependencies:
   - Ensure `package.json` exists and `node_modules` is not copied during build.
2. Docker Compose can't start a service (image not found):
   - Ensure `build:` path is correct or use `image:` with prebuilt image.
3. CORS or cookie issues behind API Gateway:
   - API Gateway must forward credentials and not pre-parse body; prefer `changeOrigin: true` and avoid global `express.json()` in gateway that proxies to services.
4. Minikube resources low:
   - Restart minikube with larger resources: `minikube start --cpus=4 --memory=8192`
5. Emails not sending:
   - Check Notification Service logs and environment variables (SMTP). Use `kubectl logs` or `docker logs` to inspect.


---

## Quick Next Steps (what I can do now)

I can proceed right away with any of the following—tell me which you want me to run now (I suggest doing them sequentially):

1. Build Docker images for all services locally and capture outputs (I will run `docker build` commands).  
2. Create a `docker-compose.yml`, run `docker compose up --build -d`, verify services.  
3. Produce Kubernetes manifests under `k8s/` (Deployments, Services, ConfigMaps, Secrets).  
4. Start Minikube and deploy manifests.  
5. Create a GitHub Actions sample for CI/CD.

If you want me to continue now, reply: `Yes — build images and run compose` or pick a step. If you'd rather do the runs locally while I guide, choose `Guide me`.

---

## Appendix — Useful commands cheat-sheet

```powershell
# Build image
cd services\user-service
docker build -t automernate-user:dev .

# Compose up
docker compose up --build -d

# List containers
docker ps

# Minikube start
minikube start --driver=hyperv --cpus=4 --memory=4096

# Apply k8s manifests
kubectl apply -f k8s/manifests/ -R

# Check pods
kubectl get pods -n automernate

# Check service
kubectl get svc -n automernate

# Logs
kubectl logs -n automernate <pod-name>
```

---

Please confirm whether you want me to immediately start building Docker images and running `docker compose up`, or prefer to follow the steps yourself while I guide you. If you want me to run them, I'll proceed now and capture outputs.

Good luck — we can complete the whole pipeline together quickly. Replace the screenshot placeholders with the image files you collect and I'll help polish the final submission text if you want.