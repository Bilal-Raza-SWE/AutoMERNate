# AutoMERNate — Final Submission

> Single, comprehensive submission-ready document for the MLOps Assignment #2 (DevOps & MLOps Phase). This file documents the system, what was changed during development, and provides a step-by-step DevOps guide (Docker, Docker Compose, Kubernetes/Minikube), plus explicit screenshot placeholders you must replace with captured images.

---

## Table of Contents

1. Executive Summary
2. System Architecture & Components
3. Development Fixes & Verification (what I changed)
4. Environment & Prerequisites
5. Phase 1 — Dockerization (per-service)
6. Phase 2 — Docker Compose
7. Phase 3 — Kubernetes on Minikube
8. Phase 4 — Scaling & Validation
9. Phase 5 — Monitoring & Debugging
10. CI/CD (optional) — GitHub Actions example
11. Troubleshooting & Common Fixes
12. Screenshots list & naming conventions
13. Appendix — Commands cheat sheet

---

## 1. Executive Summary

This repository implements AutoMERNate (a MERN-based e-commerce platform) using a microservices architecture. The submission demonstrates:

- Functional microservices (frontend, API Gateway, product, user, order, payment, notification)
- Fixes applied during development (API Gateway proxy, password reset flow, email integration)
- Full DevOps workflow: Dockerfiles, Docker Compose orchestration, and Kubernetes manifests for Minikube
- Step-by-step commands and screenshot placeholders so you can collect evidence for the assignment submission

Use this file as your final report. Replace every screenshot placeholder like `[Screenshot 01 – ...]` with actual images and files named as suggested in the "Screenshots list" section.

---

## 2. System Architecture & Components

High-level diagram (describe in words, include your own architecture image if required):
- React frontend served on port 3000
- API Gateway (Express + http-proxy-middleware) on port 5000
- Microservices (Express + MongoDB): Products (5001), Users (5002), Orders (5003), Payment (5004), Notification (5005)
- Database: MongoDB Atlas (cloud-hosted). For local orchestration you can replace with a local MongoDB container.

Key technologies used:
- Node.js, Express
- React (frontend)
- MongoDB / Mongoose
- Docker & Docker Compose
- Kubernetes (Minikube) and kubectl
- JWT for authentication

Take Screenshot: `[Screenshot ARCH-01 — System architecture diagram]`

---

## 3. Development Fixes & Verification

This project required a few critical fixes during testing. Include these as part of your submission (with supporting screenshots or CLI outputs where possible).

A. API Gateway proxy POST failures
- Problem: API Gateway was consuming request body (global express.json()) before proxying, causing failed proxy POSTs and "failed to fetch" errors from frontend.
- Fix: Removed global `express.json()` in API Gateway. Added body parsing only for local test routes and let the proxy forward requests unmodified.
- File updated: `services/api-gateway/server.js` (see logs in repo or include code snippet).
- Verification: Registration and login endpoints working through gateway.

B. Password reset 404 and email sending
- Problem: Password-reset routes were missing in `user-service` causing 404. Additionally, controller returned token but didn't send email.
- Fixes:
  1. Added `requestPasswordReset` and `resetPassword` controller functions in `services/user-service/controllers/userController.js`.
  2. Added routes in `services/user-service/routes/userRoutes.js`:
     - `POST /api/v1/users/reset-password/request`
     - `POST /api/v1/users/reset-password/reset`
  3. Integrated Notification Service by calling `http://localhost:5005/api/v1/notifications/email` from the user service controller. The Notification Service uses SMTP (Gmail) and a `.env` for credentials.
- Verification: The password-reset POST returns 200 and email is sent (test with your inbox).

Take Screenshot: `[Screenshot DEV-01 — API Gateway log showing proxied POST]`
Take Screenshot: `[Screenshot DEV-02 — User Service route listing showing reset-password routes]`
Take Screenshot: `[Screenshot DEV-03 — Received reset email in Gmail (inbox or spam)]`

---

## 4. Environment & Prerequisites

Local machine requirements (Windows):
- Node.js (v18+ recommended). Verified earlier.
- Docker Desktop (with WSL2 or Hyper-V) or Docker Engine + Docker Compose v2
- kubectl
- minikube
- (Optional) Docker Hub account if you push images

Commands to verify installs (PowerShell):

```powershell
node -v
npm -v
docker --version
docker compose version
kubectl version --client --short
minikube version
```

Take Screenshot: `[Screenshot 00 – Environment check: node, docker, kubectl, minikube]`

Notes on .env and secrets
- Keep sensitive values out of the repo. Use a root `.env` for local runs and mount / pass secrets to Docker and K8s.
- Required env vars (example):
  - MONGO_URI
  - JWT_SECRET
  - EMAIL_HOST, EMAIL_PORT, EMAIL_USER, EMAIL_PASS

---

## 5. Phase 1 — Dockerization (per-service)

Goal: Create verified Dockerfiles for each service. I used these recommended patterns — adjust to your exact file locations.

A. Backend microservice Dockerfile (example: User Service)

```dockerfile
# services/user-service/Dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --silent
COPY . .
EXPOSE 5002
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s CMD wget -qO- http://localhost:5002/health || exit 1
CMD ["node", "server.js"]
```

Explanation (line-by-line):
- `FROM node:18-alpine` — lightweight Node base
- `WORKDIR /app` — working directory
- Copy package manifests and `npm ci` to leverage caching
- Copy source code
- `HEALTHCHECK` ensures container reports unhealthy if service is down
- `CMD` runs server

B. Frontend Dockerfile (multi-stage build)

```dockerfile
# frontend/Dockerfile
# Stage 1: build
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --silent
COPY . .
RUN npm run build

# Stage 2: serve
FROM nginx:1.25-alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/build /usr/share/nginx/html
EXPOSE 80
```

Take Screenshot: `[Screenshot 01 – User Service Dockerfile]`
Take Screenshot: `[Screenshot 02 – Frontend Dockerfile (multi-stage)]`

C. Build images

For each service (example):

```powershell
cd services\user-service
docker build -t automernate-user:dev .
cd ..\api-gateway
docker build -t automernate-api-gateway:dev .
cd ..\frontend
docker build -t automernate-frontend:dev .
```

Take Screenshot: `[Screenshot 03 – docker build output for services]`

After building, list images:

```powershell
docker images | findstr automernate
```

Take Screenshot: `[Screenshot 04 – docker images list showing built images]`

---

## 6. Phase 2 — Docker Compose

Create `docker-compose.yml` at repository root. Example skeleton below (expand for each service and environment variables):

```yaml
version: '3.8'
services:
  frontend:
    build: ./frontend
    image: automernate-frontend:dev
    ports:
      - '3000:80'
    depends_on:
      - api-gateway

  api-gateway:
    build: ./services/api-gateway
    image: automernate-api-gateway:dev
    ports:
      - '5000:5000'
    environment:
      - NODE_ENV=production
    depends_on:
      - user-service
      - product-service

  user-service:
    build: ./services/user-service
    image: automernate-user:dev
    ports:
      - '5002:5002'
    environment:
      - MONGO_URI=${MONGO_URI}
      - JWT_SECRET=${JWT_SECRET}

  # ... other microservices

networks:
  default:
    driver: bridge
```

Notes:
- Create a `.env` at repo root with sensitive values (not committed to git). Docker Compose will automatically load `.env`.
- For local testing you can map DB to a local mongo container OR point to Atlas.

Commands to run:

```powershell
docker compose up --build -d
docker compose ps
docker compose logs -f
```

Take Screenshot: `[Screenshot 05 – docker-compose.yml file open in editor]`
Take Screenshot: `[Screenshot 06 – docker compose up output showing services starting]`
Take Screenshot: `[Screenshot 07 – docker ps showing all containers running]`
Take Screenshot: `[Screenshot 08 – Browser showing frontend at http://localhost:3000]`

---

## 7. Phase 3 — Kubernetes (Minikube)

### 7.0 Start Minikube

Start minikube with sufficient resources:

```powershell
minikube start --driver=hyperv --cpus=4 --memory=8192
```

Take Screenshot: `[Screenshot 09 – minikube start output]`

Show status:

```powershell
minikube status
kubectl version --client --short
```

Take Screenshot: `[Screenshot 10 – kubectl version and minikube status]`

### 7.1 Namespace

```powershell
kubectl create namespace automernate
kubectl config set-context --current --namespace=automerate
```

Take Screenshot: `[Screenshot 11 – kubectl get namespaces showing automernate]`

### 7.2 Manifests (example)

Place all manifests under `k8s/manifests/` (create folder). Each microservice needs at minimum:
- `deployment-<service>.yaml`
- `service-<service>.yaml`
- `configmap-<service>.yaml` (if needed)
- `secret-<service>.yaml` (for DB URIs / JWT / SMTP)

Example `deployment-user.yaml`:

```yaml
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
          env:
            - name: MONGO_URI
              valueFrom:
                secretKeyRef:
                  name: user-service-secrets
                  key: mongo_uri
            - name: JWT_SECRET
              valueFrom:
                secretKeyRef:
                  name: user-service-secrets
                  key: jwt_secret
          readinessProbe:
            httpGet:
              path: /health
              port: 5002
            initialDelaySeconds: 5
            periodSeconds: 10
```

Example `service-user.yaml` (NodePort for testing):

```yaml
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

Create secrets (example):

```powershell
kubectl create secret generic user-service-secrets \
  --from-literal=mongo_uri="<your-mongo-uri>" \
  --from-literal=jwt_secret="your-secret" -n automernate
```

### 7.3 Apply manifests

```powershell
kubectl apply -f k8s/manifests/ -R -n automernate
```

Take Screenshot: `[Screenshot 12 – kubectl apply output for all manifests]`

Verify:

```powershell
kubectl get pods -n automernate
kubectl get svc -n automernate
```

Take Screenshot: `[Screenshot 13 – kubectl get pods showing all services running]`
Take Screenshot: `[Screenshot 14 – kubectl get svc showing NodePort/ClusterIP mappings]`

### 7.4 Accessing Frontend

Option A (NodePort):

```powershell
$IP = minikube ip
# Suppose frontend nodePort = 30080
# Browser: http://$IP:30080
```

Option B (Ingress):

```powershell
minikube addons enable ingress
kubectl apply -f k8s/ingress.yaml -n automernate
```

Take Screenshot: `[Screenshot 15 – Browser screenshot showing frontend served from Minikube IP]`

---

## 8. Phase 4 — Scaling & Validation

Scale a deployment (example):

```powershell
kubectl scale deployment user-service --replicas=6 -n automernate
kubectl get pods -l app=user-service -n automernate
```

Take Screenshot: `[Screenshot 16 – kubectl scale command output]`
Take Screenshot: `[Screenshot 17 – kubectl get pods showing scaled replicas]`
Take Screenshot: `[Screenshot 18 – kubectl rollout status user-service]`

---

## 9. Phase 5 — Monitoring & Debugging

Useful commands:
- `kubectl logs <pod-name> -n automernate`
- `kubectl describe pod <pod-name> -n automernate`
- `kubectl get events -n automernate`
- `minikube dashboard`

Take Screenshot: `[Screenshot 19 – minikube dashboard overview]`
Take Screenshot: `[Screenshot 20 – kubectl logs <pod-name> showing successful requests]`

---

## 10. CI/CD (GitHub Actions example)

A minimal GitHub Actions workflow to build images and (optionally) push to Docker Hub and deploy to Minikube (or run integration tests). Save as `.github/workflows/ci-cd.yml`.

```yaml
name: CI/CD
on: [push]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v2
      - name: Login to DockerHub
        uses: docker/login-action@v2
        with:
          username: ${{ secrets.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}
      - name: Build and push images
        uses: docker/build-push-action@v4
        with:
          context: ./services/user-service
          push: true
          tags: ${{ secrets.DOCKERHUB_USERNAME }}/automerate-user:latest
```

Explain each step in your report and attach this as `fig_ci_cd_workflow.png` if required.

---

## 11. Troubleshooting & Common Fixes

Include the problems you encountered and how you fixed them (these are strong evidence):
- API Gateway body parsing / proxy errors — removed express.json across proxy routes
- Stale gateway process — kill and restart when port blocked
- Missing user reset routes — added endpoints
- Email sending failing — ensure Notification Service loads `.env` (or root `.env`), verify SMTP and logs

Take Screenshot: `[Screenshot TR-01 – Error logs before/after fix]`

---

## 12. Screenshots list & naming conventions

Replace placeholders in this document with actual images and store them alongside this Markdown file (or in a `screenshots/` folder). Use these suggested filenames:

- `fig00_environment_check.png` — `[Screenshot 00]`
- `fig01_user_dockerfile.png` — `[Screenshot 01]`
- `fig02_frontend_dockerfile.png` — `[Screenshot 02]`
- `fig03_docker_build_output.png` — `[Screenshot 03]`
- `fig04_docker_images.png` — `[Screenshot 04]`
- `fig05_docker_compose_up.png` — `[Screenshot 06]`
- `fig06_docker_ps.png` — `[Screenshot 07]`
- `fig07_frontend_local.png` — `[Screenshot 08]`
- `fig08_minikube_start.png` — `[Screenshot 09]`
- `fig09_kubectl_status.png` — `[Screenshot 10]`
- `fig10_kubectl_pods.png` — `[Screenshot 13]`
- `fig11_kubectl_services.png` — `[Screenshot 14]`
- `fig12_frontend_minikube.png` — `[Screenshot 15]`
- `fig13_scaling.png` — `[Screenshot 16/17]`
- `fig14_minikube_dashboard.png` — `[Screenshot 19]`
- `fig15_logs_backend.png` — `[Screenshot 20]`

In the final report, caption each figure with its filename and a short description. Example:

> Figure X — `fig03_docker_build_output.png`: Docker build output for `user-service`.

---

## 13. Appendix — Commands cheat sheet (copy/paste ready)

PowerShell / Windows-friendly commands:

```powershell
# Build specific service image
cd services\user-service
docker build -t automernate-user:dev .

# Build all images from root (one by one)
# (repeat for each service)

# Docker compose up
docker compose up --build -d

docker compose ps

docker compose logs -f

# Minikube
minikube start --driver=hyperv --cpus=4 --memory=8192
minikube ip
kubectl create namespace automernate
kubectl apply -f k8s/manifests/ -R -n automernate
kubectl get pods -n automernate
kubectl get svc -n automernate
kubectl logs -n automernate <pod-name>

# Create secrets
kubectl create secret generic user-service-secrets \
  --from-literal=mongo_uri="<your-mongo-uri>" \
  --from-literal=jwt_secret="your-secret" -n automernate
```

---

## Final Checklist before submission

- [ ] Replace all screenshot placeholders with actual images named per the convention
- [ ] Verify all commands run on your machine and collect outputs/screenshots
- [ ] Include short description for each screenshot in the report
- [ ] Add `k8s/manifests/` folder and include all YAMLs used to deploy
- [ ] (Optional) Add CI workflow in `.github/workflows/` and include the workflow screenshot

---

If you'd like, I can now (choose one):

- Build Docker images for all services and capture the build output (I will run builds locally here). Reply: `Build images now`.
- Create a `docker-compose.yml` for the complete stack (I will author it and place it at repo root). Reply: `Create compose`.
- Generate `k8s/` manifests for every service (Deployments, Services, ConfigMaps, Secrets). Reply: `Create k8s manifests`.
- Generate a sample GitHub Actions workflow and push to `.github/workflows/ci-cd.yml`. Reply: `Create CI`.

If you want me to perform the runs (build/compose/minikube apply) from this environment, say `Run` and which step. I can run them and capture outputs, but note: building images and starting minikube may take several minutes.

Good — tell me which of the above you'd like me to execute first and I'll proceed immediately.