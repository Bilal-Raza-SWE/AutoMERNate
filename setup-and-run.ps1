# AutoMERNate - Complete Setup and Run Script
# Author: Muhammad Bilal Raza Attari

Write-Host "=======================================" -ForegroundColor Cyan
Write-Host "   AutoMERNate System Setup & Launch   " -ForegroundColor Cyan
Write-Host "=======================================" -ForegroundColor Cyan
Write-Host ""

# Function to check if running as Administrator
function Test-Administrator {
    $currentUser = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $currentUser.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Step 1: Check Docker
Write-Host "Step 1: Checking Docker..." -ForegroundColor Yellow
try {
    $dockerVersion = docker --version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Docker is installed: $dockerVersion" -ForegroundColor Green
    } else {
        Write-Host "❌ Docker is not running or not installed" -ForegroundColor Red
        Write-Host "Please start Docker Desktop and try again." -ForegroundColor Yellow
        exit 1
    }
} catch {
    Write-Host "❌ Docker is not installed or not in PATH" -ForegroundColor Red
    exit 1
}

Write-Host ""

# Step 2: Check Node.js
Write-Host "Step 2: Checking Node.js..." -ForegroundColor Yellow
try {
    $nodeVersion = node --version
    $npmVersion = npm --version
    Write-Host "✅ Node.js: $nodeVersion" -ForegroundColor Green
    Write-Host "✅ npm: $npmVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Node.js is not installed" -ForegroundColor Red
    Write-Host "Please install Node.js from https://nodejs.org/" -ForegroundColor Yellow
    exit 1
}

Write-Host ""

# Step 3: Determine run mode
Write-Host "=======================================" -ForegroundColor Cyan
Write-Host "Choose how to run AutoMERNate:" -ForegroundColor Cyan
Write-Host "1. Docker Compose (Recommended - Containerized)" -ForegroundColor White
Write-Host "2. Local Development (Node.js services)" -ForegroundColor White
Write-Host "3. Kubernetes (Minikube/K8s cluster required)" -ForegroundColor White
Write-Host "=======================================" -ForegroundColor Cyan
Write-Host ""

$choice = Read-Host "Enter your choice (1, 2, or 3)"

switch ($choice) {
    "1" {
        Write-Host ""
        Write-Host "Starting with Docker Compose..." -ForegroundColor Green
        Write-Host ""
        
        # Check if .env exists
        if (-Not (Test-Path ".env")) {
            Write-Host "⚠️  .env file not found. Creating from .env.example..." -ForegroundColor Yellow
            if (Test-Path ".env.example") {
                Copy-Item ".env.example" ".env"
                Write-Host "✅ .env file created. Please update it with your credentials." -ForegroundColor Green
                Write-Host "Opening .env file for editing..." -ForegroundColor Yellow
                Start-Process notepad ".env"
                Read-Host "Press Enter after you've updated the .env file"
            } else {
                Write-Host "❌ .env.example not found!" -ForegroundColor Red
                exit 1
            }
        }
        
        Write-Host "Building and starting Docker containers..." -ForegroundColor Cyan
        docker-compose -f docker-compose-microservices.yml up --build -d
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host ""
            Write-Host "✅ All services started successfully!" -ForegroundColor Green
            Write-Host ""
            Write-Host "Services running:" -ForegroundColor Cyan
            Write-Host "  - Frontend: http://localhost:3000" -ForegroundColor White
            Write-Host "  - API Gateway: http://localhost:5000" -ForegroundColor White
            Write-Host "  - Product Service: http://localhost:5001" -ForegroundColor White
            Write-Host "  - User Service: http://localhost:5002" -ForegroundColor White
            Write-Host "  - Order Service: http://localhost:5003" -ForegroundColor White
            Write-Host "  - Payment Service: http://localhost:5004" -ForegroundColor White
            Write-Host "  - Notification Service: http://localhost:5005" -ForegroundColor White
            Write-Host ""
            Write-Host "View logs: docker-compose -f docker-compose-microservices.yml logs -f" -ForegroundColor Yellow
            Write-Host "Stop services: docker-compose -f docker-compose-microservices.yml down" -ForegroundColor Yellow
        } else {
            Write-Host "❌ Failed to start Docker services" -ForegroundColor Red
        }
    }
    
    "2" {
        Write-Host ""
        Write-Host "Starting Local Development Mode..." -ForegroundColor Green
        Write-Host ""
        
        # Check if node_modules exist in services
        $services = @("product-service", "user-service", "order-service", "payment-service", "notification-service", "api-gateway")
        
        Write-Host "Checking dependencies..." -ForegroundColor Yellow
        foreach ($service in $services) {
            $servicePath = "services\$service"
            if (-Not (Test-Path "$servicePath\node_modules")) {
                Write-Host "Installing dependencies for $service..." -ForegroundColor Cyan
                Push-Location $servicePath
                npm install
                Pop-Location
            }
        }
        
        # Check frontend dependencies
        if (-Not (Test-Path "frontend\node_modules")) {
            Write-Host "Installing frontend dependencies..." -ForegroundColor Cyan
            Push-Location frontend
            npm install
            Pop-Location
        }
        
        Write-Host ""
        Write-Host "✅ All dependencies installed!" -ForegroundColor Green
        Write-Host ""
        Write-Host "Starting all services..." -ForegroundColor Cyan
        
        # Run the start-all-services script
        & ".\start-all-services.ps1"
    }
    
    "3" {
        Write-Host ""
        Write-Host "Starting with Kubernetes..." -ForegroundColor Green
        Write-Host ""
        
        # Check if kubectl is available
        try {
            kubectl version --client | Out-Null
            Write-Host "✅ kubectl is installed" -ForegroundColor Green
        } catch {
            Write-Host "❌ kubectl is not installed" -ForegroundColor Red
            Write-Host "Please install kubectl from https://kubernetes.io/docs/tasks/tools/" -ForegroundColor Yellow
            exit 1
        }
        
        Write-Host "Deploying to Kubernetes..." -ForegroundColor Cyan
        & ".\deploy-k8s-microservices.ps1"
    }
    
    default {
        Write-Host "Invalid choice. Please run the script again and select 1, 2, or 3." -ForegroundColor Red
        exit 1
    }
}

Write-Host ""
Write-Host "=======================================" -ForegroundColor Cyan
Write-Host "   Setup Complete!                     " -ForegroundColor Cyan
Write-Host "=======================================" -ForegroundColor Cyan
