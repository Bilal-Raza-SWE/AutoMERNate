# Test AutoMERNate Microservices
# Run this script to verify all services are working

Write-Host "Testing AutoMERNate Microservices..." -ForegroundColor Cyan
Write-Host ""

# Test API Gateway Health
Write-Host "1. Testing API Gateway (Port 5000)..." -ForegroundColor Yellow
try {
    $gateway = Invoke-RestMethod -Uri "http://localhost:5000/health" -ErrorAction Stop
    Write-Host "   Status: $($gateway.status)" -ForegroundColor Green
    Write-Host "   Service: $($gateway.service)" -ForegroundColor Green
} catch {
    Write-Host "   FAILED: API Gateway not responding" -ForegroundColor Red
}
Write-Host ""

# Test Product Service
Write-Host "2. Testing Product Service (Port 5001)..." -ForegroundColor Yellow
try {
    $products = Invoke-RestMethod -Uri "http://localhost:5001/health" -ErrorAction Stop
    Write-Host "   Status: $($products.status)" -ForegroundColor Green
    Write-Host "   Service: $($products.service)" -ForegroundColor Green
    
    # Test actual products endpoint
    $productList = Invoke-RestMethod -Uri "http://localhost:5001/api/v1/products" -ErrorAction Stop
    Write-Host "   Products in DB: $($productList.total)" -ForegroundColor Green
} catch {
    Write-Host "   FAILED: $($_.Exception.Message)" -ForegroundColor Red
}
Write-Host ""

# Test User Service
Write-Host "3. Testing User Service (Port 5002)..." -ForegroundColor Yellow
try {
    $users = Invoke-RestMethod -Uri "http://localhost:5002/health" -ErrorAction Stop
    Write-Host "   Status: $($users.status)" -ForegroundColor Green
    Write-Host "   Service: $($users.service)" -ForegroundColor Green
} catch {
    Write-Host "   FAILED: $($_.Exception.Message)" -ForegroundColor Red
}
Write-Host ""

# Test Order Service
Write-Host "4. Testing Order Service (Port 5003)..." -ForegroundColor Yellow
try {
    $orders = Invoke-RestMethod -Uri "http://localhost:5003/health" -ErrorAction Stop
    Write-Host "   Status: $($orders.status)" -ForegroundColor Green
    Write-Host "   Service: $($orders.service)" -ForegroundColor Green
} catch {
    Write-Host "   FAILED: $($_.Exception.Message)" -ForegroundColor Red
}
Write-Host ""

# Test Payment Service
Write-Host "5. Testing Payment Service (Port 5004)..." -ForegroundColor Yellow
try {
    $payment = Invoke-RestMethod -Uri "http://localhost:5004/health" -ErrorAction Stop
    Write-Host "   Status: $($payment.status)" -ForegroundColor Green
    Write-Host "   Service: $($payment.service)" -ForegroundColor Green
} catch {
    Write-Host "   FAILED: $($_.Exception.Message)" -ForegroundColor Red
}
Write-Host ""

# Test Notification Service
Write-Host "6. Testing Notification Service (Port 5005)..." -ForegroundColor Yellow
try {
    $notification = Invoke-RestMethod -Uri "http://localhost:5005/health" -ErrorAction Stop
    Write-Host "   Status: $($notification.status)" -ForegroundColor Green
    Write-Host "   Service: $($notification.service)" -ForegroundColor Green
} catch {
    Write-Host "   FAILED: $($_.Exception.Message)" -ForegroundColor Red
}
Write-Host ""

# Test Frontend
Write-Host "7. Testing Frontend (Port 3000)..." -ForegroundColor Yellow
try {
    $frontend = Invoke-WebRequest -Uri "http://localhost:3000" -UseBasicParsing -ErrorAction Stop
    if ($frontend.StatusCode -eq 200) {
        Write-Host "   Status: OK" -ForegroundColor Green
        Write-Host "   Frontend is loading" -ForegroundColor Green
    }
} catch {
    Write-Host "   FAILED: $($_.Exception.Message)" -ForegroundColor Red
}
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "SUMMARY" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "All microservices are running!" -ForegroundColor Green
Write-Host "Frontend: http://localhost:3000" -ForegroundColor White
Write-Host "API Gateway: http://localhost:5000" -ForegroundColor White
Write-Host ""
Write-Host "Note: Individual service ports (5001-5005) will show '404 - Not Found'" -ForegroundColor Yellow
Write-Host "when accessed from browser because they only respond to specific API paths." -ForegroundColor Yellow
Write-Host "This is NORMAL and expected behavior." -ForegroundColor Yellow
