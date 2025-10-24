# AutoMERNate Kubernetes Deployment Script
# Author: Muhammad Bilal Raza Attari
# This script deploys the AutoMERNate application to Minikube

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "   AutoMERNate Kubernetes Deployment Script    " -ForegroundColor Cyan
Write-Host "   Author: Muhammad Bilal Raza Attari          " -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Check if Minikube is running
Write-Host "[Step 1] Checking Minikube status..." -ForegroundColor Yellow
$minikubeStatus = minikube status 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "Minikube is not running. Starting Minikube..." -ForegroundColor Yellow
    minikube start --driver=docker --cpus=4 --memory=4096
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Failed to start Minikube!" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "Minikube is already running!" -ForegroundColor Green
}

# Step 2: Set Docker environment to use Minikube's Docker daemon
Write-Host "`n[Step 2] Configuring Docker to use Minikube's Docker daemon..." -ForegroundColor Yellow
& minikube -p minikube docker-env --shell powershell | Invoke-Expression

# Step 3: Build Docker images
Write-Host "`n[Step 3] Building Docker images..." -ForegroundColor Yellow

Write-Host "  Building backend image..." -ForegroundColor Cyan
docker build -t automernate-backend:latest -f backend/Dockerfile .
if ($LASTEXITCODE -ne 0) {
    Write-Host "Failed to build backend image!" -ForegroundColor Red
    exit 1
}

Write-Host "  Building frontend image..." -ForegroundColor Cyan
docker build -t automernate-frontend:latest -f frontend/Dockerfile ./frontend
if ($LASTEXITCODE -ne 0) {
    Write-Host "Failed to build frontend image!" -ForegroundColor Red
    exit 1
}

Write-Host "Docker images built successfully!" -ForegroundColor Green

# Step 4: Apply Kubernetes manifests
Write-Host "`n[Step 4] Deploying to Kubernetes..." -ForegroundColor Yellow

Write-Host "  Creating ConfigMap..." -ForegroundColor Cyan
kubectl apply -f k8s/configmap.yaml

Write-Host "  Creating Secrets..." -ForegroundColor Cyan
kubectl apply -f k8s/secret.yaml

Write-Host "  Deploying MongoDB..." -ForegroundColor Cyan
kubectl apply -f k8s/mongodb-deployment.yaml

Write-Host "  Waiting for MongoDB to be ready..." -ForegroundColor Cyan
kubectl wait --for=condition=available --timeout=120s deployment/automernate-mongodb

Write-Host "  Deploying Backend..." -ForegroundColor Cyan
kubectl apply -f k8s/backend-deployment.yaml

Write-Host "  Deploying Frontend..." -ForegroundColor Cyan
kubectl apply -f k8s/frontend-deployment.yaml

# Step 5: Wait for all deployments to be ready
Write-Host "`n[Step 5] Waiting for all deployments to be ready..." -ForegroundColor Yellow
kubectl wait --for=condition=available --timeout=180s deployment/automernate-backend
kubectl wait --for=condition=available --timeout=180s deployment/automernate-frontend

# Step 6: Display deployment status
Write-Host "`n[Step 6] Deployment Status:" -ForegroundColor Yellow
kubectl get all -l app=automernate

# Step 7: Get Minikube IP and service URLs
Write-Host "`n[Step 7] Access Information:" -ForegroundColor Yellow
$minikubeIP = minikube ip
Write-Host "Minikube IP: $minikubeIP" -ForegroundColor Green
Write-Host "Frontend URL: http://${minikubeIP}:30300" -ForegroundColor Green
Write-Host "Backend URL: http://${minikubeIP}:30500" -ForegroundColor Green

Write-Host "`n================================================" -ForegroundColor Cyan
Write-Host "   Deployment Complete!                         " -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "`nUseful Commands:" -ForegroundColor Yellow
Write-Host "  View pods:        kubectl get pods" -ForegroundColor Cyan
Write-Host "  View services:    kubectl get services" -ForegroundColor Cyan
Write-Host "  View logs:        kubectl logs <pod-name>" -ForegroundColor Cyan
Write-Host "  Scale replicas:   kubectl scale deployment automernate-backend --replicas=5" -ForegroundColor Cyan
Write-Host "  Delete all:       kubectl delete -f k8s/" -ForegroundColor Cyan
