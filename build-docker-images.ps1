# AutoMERNate Microservices - Docker Build & Push Script
# Author: Muhammad Bilal Raza Attari

Write-Host "🐳 Building Docker Images for AutoMERNate Microservices" -ForegroundColor Cyan
Write-Host "=======================================================" -ForegroundColor Cyan

$DOCKER_USERNAME = "bilalrazaswe"

# Build Product Service
Write-Host "`n📦 Building Product Service..." -ForegroundColor Yellow
docker build -t ${DOCKER_USERNAME}/automernate-product-service:latest ./services/product-service
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Product Service built successfully" -ForegroundColor Green
} else {
    Write-Host "❌ Product Service build failed" -ForegroundColor Red
    exit 1
}

# Build User Service
Write-Host "`n👤 Building User Service..." -ForegroundColor Yellow
docker build -t ${DOCKER_USERNAME}/automernate-user-service:latest ./services/user-service
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ User Service built successfully" -ForegroundColor Green
} else {
    Write-Host "❌ User Service build failed" -ForegroundColor Red
    exit 1
}

# Build Order Service
Write-Host "`n📋 Building Order Service..." -ForegroundColor Yellow
docker build -t ${DOCKER_USERNAME}/automernate-order-service:latest ./services/order-service
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Order Service built successfully" -ForegroundColor Green
} else {
    Write-Host "❌ Order Service build failed" -ForegroundColor Red
    exit 1
}

# Build Payment Service
Write-Host "`n💳 Building Payment Service..." -ForegroundColor Yellow
docker build -t ${DOCKER_USERNAME}/automernate-payment-service:latest ./services/payment-service
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Payment Service built successfully" -ForegroundColor Green
} else {
    Write-Host "❌ Payment Service build failed" -ForegroundColor Red
    exit 1
}

# Build API Gateway
Write-Host "`n🚪 Building API Gateway..." -ForegroundColor Yellow
docker build -t ${DOCKER_USERNAME}/automernate-api-gateway:latest ./services/api-gateway
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ API Gateway built successfully" -ForegroundColor Green
} else {
    Write-Host "❌ API Gateway build failed" -ForegroundColor Red
    exit 1
}

# Build Frontend
Write-Host "`n🌐 Building Frontend..." -ForegroundColor Yellow
docker build -t ${DOCKER_USERNAME}/automernate-frontend:latest ./frontend
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Frontend built successfully" -ForegroundColor Green
} else {
    Write-Host "❌ Frontend build failed" -ForegroundColor Red
    exit 1
}

Write-Host "`n✅ All Docker images built successfully!" -ForegroundColor Green
Write-Host "`n📋 Built Images:" -ForegroundColor Cyan
docker images | Select-String "automernate"

Write-Host "`n🚀 Push images to Docker Hub? (docker login required)" -ForegroundColor Yellow
Write-Host "   Run: docker push ${DOCKER_USERNAME}/automernate-product-service:latest" -ForegroundColor Gray
Write-Host "   Run: docker push ${DOCKER_USERNAME}/automernate-user-service:latest" -ForegroundColor Gray
Write-Host "   Run: docker push ${DOCKER_USERNAME}/automernate-order-service:latest" -ForegroundColor Gray
Write-Host "   Run: docker push ${DOCKER_USERNAME}/automernate-payment-service:latest" -ForegroundColor Gray
Write-Host "   Run: docker push ${DOCKER_USERNAME}/automernate-api-gateway:latest" -ForegroundColor Gray
Write-Host "   Run: docker push ${DOCKER_USERNAME}/automernate-frontend:latest" -ForegroundColor Gray
