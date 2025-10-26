# AutoMERNate - Start All Services
# Author: Muhammad Bilal Raza Attari

Write-Host "Starting AutoMERNate Microservices..." -ForegroundColor Green
Write-Host ""

$projectRoot = "d:\FAST NU\Semester - 07\MLOPs\i222559_SE-B_Assignment-02\AutoMernate"

# Start Product Service
Write-Host "Starting Product Service..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$projectRoot\services\product-service'; npm start"
Start-Sleep -Seconds 2

# Start User Service
Write-Host "Starting User Service..." -ForegroundColor Cyan
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$projectRoot\services\user-service'; npm start"
Start-Sleep -Seconds 2

# Start Order Service
Write-Host "Starting Order Service..." -ForegroundColor Magenta
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$projectRoot\services\order-service'; npm start"
Start-Sleep -Seconds 2

# Start Payment Service
Write-Host "Starting Payment Service..." -ForegroundColor Green
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$projectRoot\services\payment-service'; npm start"
Start-Sleep -Seconds 2

# Start Notification Service
Write-Host "Starting Notification Service..." -ForegroundColor Blue
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$projectRoot\services\notification-service'; npm start"
Start-Sleep -Seconds 2

# Start API Gateway
Write-Host "Starting API Gateway..." -ForegroundColor Red
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$projectRoot\services\api-gateway'; npm start"
Start-Sleep -Seconds 3

# Start Frontend
Write-Host "Starting Frontend..." -ForegroundColor White
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$projectRoot\frontend'; npm start"

Write-Host ""
Write-Host "All services are starting in separate windows!" -ForegroundColor Green
Write-Host "Wait 30 seconds for all services to initialize..." -ForegroundColor Yellow
Write-Host ""
Write-Host "Services:" -ForegroundColor Cyan
Write-Host "  - Product Service: http://localhost:5001"
Write-Host "  - User Service: http://localhost:5002"
Write-Host "  - Order Service: http://localhost:5003"
Write-Host "  - Payment Service: http://localhost:5004"
Write-Host "  - Notification Service: http://localhost:5005"
Write-Host "  - API Gateway: http://localhost:5000"
Write-Host "  - Frontend: http://localhost:3000"
Write-Host ""
Write-Host "Open your browser at: http://localhost:3000" -ForegroundColor Green
