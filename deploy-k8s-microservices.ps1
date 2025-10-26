# AutoMERNate Microservices - Kubernetes Deployment Script
# Author: Muhammad Bilal Raza Attari

Write-Host "☸️  Deploying AutoMERNate Microservices to Kubernetes" -ForegroundColor Cyan
Write-Host "=====================================================" -ForegroundColor Cyan

# Check if kubectl is available
try {
    kubectl version --client --short | Out-Null
    Write-Host "✅ kubectl is available" -ForegroundColor Green
} catch {
    Write-Host "❌ kubectl not found. Please install kubectl first." -ForegroundColor Red
    exit 1
}

# Check if minikube is running
Write-Host "`n🔍 Checking Minikube status..." -ForegroundColor Yellow
$minikubeStatus = minikube status 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "⚠️  Minikube is not running. Starting Minikube..." -ForegroundColor Yellow
    minikube start
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Failed to start Minikube" -ForegroundColor Red
        exit 1
    }
}
Write-Host "✅ Minikube is running" -ForegroundColor Green

# Apply ConfigMap
Write-Host "`n📝 Applying ConfigMap..." -ForegroundColor Yellow
kubectl apply -f k8s/configmap-microservices.yaml
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ ConfigMap applied" -ForegroundColor Green
} else {
    Write-Host "❌ ConfigMap failed" -ForegroundColor Red
    exit 1
}

# Apply Secret
Write-Host "`n🔐 Applying Secret..." -ForegroundColor Yellow
kubectl apply -f k8s/secret.yaml
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Secret applied" -ForegroundColor Green
} else {
    Write-Host "❌ Secret failed" -ForegroundColor Red
    exit 1
}

# Deploy Product Service
Write-Host "`n📦 Deploying Product Service..." -ForegroundColor Yellow
kubectl apply -f k8s/product-service.yaml
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Product Service deployed" -ForegroundColor Green
} else {
    Write-Host "❌ Product Service deployment failed" -ForegroundColor Red
}

# Deploy User Service
Write-Host "`n👤 Deploying User Service..." -ForegroundColor Yellow
kubectl apply -f k8s/user-service.yaml
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ User Service deployed" -ForegroundColor Green
} else {
    Write-Host "❌ User Service deployment failed" -ForegroundColor Red
}

# Deploy Order Service
Write-Host "`n📋 Deploying Order Service..." -ForegroundColor Yellow
kubectl apply -f k8s/order-service.yaml
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Order Service deployed" -ForegroundColor Green
} else {
    Write-Host "❌ Order Service deployment failed" -ForegroundColor Red
}

# Deploy Payment Service
Write-Host "`n💳 Deploying Payment Service..." -ForegroundColor Yellow
kubectl apply -f k8s/payment-service.yaml
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Payment Service deployed" -ForegroundColor Green
} else {
    Write-Host "❌ Payment Service deployment failed" -ForegroundColor Red
}

# Deploy API Gateway
Write-Host "`n🚪 Deploying API Gateway..." -ForegroundColor Yellow
kubectl apply -f k8s/api-gateway.yaml
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ API Gateway deployed" -ForegroundColor Green
} else {
    Write-Host "❌ API Gateway deployment failed" -ForegroundColor Red
}

# Deploy Frontend
Write-Host "`n🌐 Deploying Frontend..." -ForegroundColor Yellow
kubectl apply -f k8s/frontend.yaml
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Frontend deployed" -ForegroundColor Green
} else {
    Write-Host "❌ Frontend deployment failed" -ForegroundColor Red
}

Write-Host "`n⏳ Waiting for deployments to be ready..." -ForegroundColor Yellow
Start-Sleep -Seconds 10

# Show deployment status
Write-Host "`n📊 Deployment Status:" -ForegroundColor Cyan
kubectl get deployments

Write-Host "`n🏃 Pod Status:" -ForegroundColor Cyan
kubectl get pods

Write-Host "`n🌐 Services:" -ForegroundColor Cyan
kubectl get services

Write-Host "`n✅ Deployment Complete!" -ForegroundColor Green
Write-Host "`n📝 Expected: 18 pods (6 services × 3 replicas)" -ForegroundColor Yellow
Write-Host "`n🌐 Access the application:" -ForegroundColor Cyan
Write-Host "   minikube service frontend --url" -ForegroundColor Gray
Write-Host "   minikube service api-gateway --url" -ForegroundColor Gray
