# AutoMERNate - Complete System Test
# Tests the microservices architecture comprehensively
# Author: Muhammad Bilal Raza Attari

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "  AutoMERNate System Test Suite         " -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

$passedTests = 0
$failedTests = 0
$totalTests = 0

function Test-Service {
    param(
        [string]$ServiceName,
        [string]$Url,
        [string]$Port
    )
    
    $global:totalTests++
    Write-Host "Testing $ServiceName (Port $Port)..." -ForegroundColor Yellow
    
    try {
        $response = Invoke-RestMethod -Uri $Url -TimeoutSec 5 -ErrorAction Stop
        Write-Host "  ✅ $ServiceName is running" -ForegroundColor Green
        Write-Host "     Status: $($response.status)" -ForegroundColor White
        if ($response.service) {
            Write-Host "     Service: $($response.service)" -ForegroundColor White
        }
        $global:passedTests++
        return $true
    } catch {
        Write-Host "  ❌ $ServiceName is NOT responding" -ForegroundColor Red
        Write-Host "     Error: $($_.Exception.Message)" -ForegroundColor Red
        $global:failedTests++
        return $false
    }
}

function Test-Endpoint {
    param(
        [string]$Description,
        [string]$Url,
        [string]$Method = "GET",
        [hashtable]$Headers = @{},
        [string]$Body = $null
    )
    
    $global:totalTests++
    Write-Host "  Testing: $Description" -ForegroundColor Cyan
    
    try {
        $params = @{
            Uri = $Url
            Method = $Method
            TimeoutSec = 5
            ErrorAction = "Stop"
        }
        
        if ($Headers.Count -gt 0) {
            $params.Headers = $Headers
        }
        
        if ($Body) {
            $params.Body = $Body
            $params.ContentType = "application/json"
        }
        
        $response = Invoke-RestMethod @params
        Write-Host "    ✅ PASSED" -ForegroundColor Green
        $global:passedTests++
        return $response
    } catch {
        Write-Host "    ❌ FAILED: $($_.Exception.Message)" -ForegroundColor Red
        $global:failedTests++
        return $null
    }
}

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "PHASE 1: ARCHITECTURE DETECTION" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# Detect architecture type
$isDockerRunning = $false
$isLocalRunning = $false

try {
    docker ps 2>&1 | Out-Null
    if ($LASTEXITCODE -eq 0) {
        $containers = docker ps --format "{{.Names}}" | Select-String "automernate"
        if ($containers) {
            $isDockerRunning = $true
            Write-Host "✅ Detected: MICROSERVICES running in DOCKER" -ForegroundColor Green
            Write-Host "   Containers found:" -ForegroundColor White
            docker ps --filter "name=automernate" --format "   - {{.Names}} ({{.Status}})"
        }
    }
} catch {
    # Docker not available
}

# Test if services are running locally
try {
    $testLocal = Invoke-RestMethod -Uri "http://localhost:5000/health" -TimeoutSec 2 -ErrorAction Stop
    $isLocalRunning = $true
    Write-Host "✅ Detected: MICROSERVICES running LOCALLY (Node.js)" -ForegroundColor Green
} catch {
    # Local services not running
}

if (-not $isDockerRunning -and -not $isLocalRunning) {
    Write-Host "❌ No running services detected!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please start the system first using one of these methods:" -ForegroundColor Yellow
    Write-Host "  1. Docker: docker-compose -f docker-compose-microservices.yml up" -ForegroundColor White
    Write-Host "  2. Local: .\start-all-services.ps1" -ForegroundColor White
    Write-Host "  3. Setup: .\setup-and-run.ps1" -ForegroundColor White
    Write-Host ""
    exit 1
}

Write-Host ""
Write-Host "Architecture Type: MICROSERVICES ✅" -ForegroundColor Green
Write-Host ""

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "PHASE 2: SERVICE HEALTH CHECKS" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# Test all services
$services = @(
    @{Name="API Gateway"; Url="http://localhost:5000/health"; Port="5000"},
    @{Name="Product Service"; Url="http://localhost:5001/health"; Port="5001"},
    @{Name="User Service"; Url="http://localhost:5002/health"; Port="5002"},
    @{Name="Order Service"; Url="http://localhost:5003/health"; Port="5003"},
    @{Name="Payment Service"; Url="http://localhost:5004/health"; Port="5004"},
    @{Name="Notification Service"; Url="http://localhost:5005/health"; Port="5005"}
)

$allServicesHealthy = $true
foreach ($service in $services) {
    $result = Test-Service -ServiceName $service.Name -Url $service.Url -Port $service.Port
    if (-not $result) {
        $allServicesHealthy = $false
    }
    Write-Host ""
}

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "PHASE 3: API ENDPOINT TESTS" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

if ($allServicesHealthy) {
    # Test Product Service Endpoints
    Write-Host "Testing Product Service APIs..." -ForegroundColor Yellow
    $products = Test-Endpoint -Description "Get all products" -Url "http://localhost:5001/api/v1/products"
    if ($products) {
        Write-Host "    Products in database: $($products.total)" -ForegroundColor White
    }
    
    Test-Endpoint -Description "Get top products" -Url "http://localhost:5001/api/v1/products/top"
    Write-Host ""
    
    # Test User Service Endpoints
    Write-Host "Testing User Service APIs..." -ForegroundColor Yellow
    Test-Endpoint -Description "User service health" -Url "http://localhost:5002/health"
    Write-Host ""
    
    # Test Order Service Endpoints
    Write-Host "Testing Order Service APIs..." -ForegroundColor Yellow
    Test-Endpoint -Description "Order service health" -Url "http://localhost:5003/health"
    Write-Host ""
    
    # Test Payment Service Endpoints
    Write-Host "Testing Payment Service APIs..." -ForegroundColor Yellow
    Test-Endpoint -Description "Payment service health" -Url "http://localhost:5004/health"
    Write-Host ""
    
    # Test Notification Service Endpoints
    Write-Host "Testing Notification Service APIs..." -ForegroundColor Yellow
    Test-Endpoint -Description "Notification service health" -Url "http://localhost:5005/health"
    Write-Host ""
    
    # Test API Gateway Routing
    Write-Host "Testing API Gateway Routing..." -ForegroundColor Yellow
    Test-Endpoint -Description "Gateway -> Products endpoint" -Url "http://localhost:5000/api/v1/products"
    Test-Endpoint -Description "Gateway -> Top products" -Url "http://localhost:5000/api/v1/products/top"
    Write-Host ""
}

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "PHASE 4: FRONTEND TEST" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

$global:totalTests++
Write-Host "Testing Frontend (Port 3000)..." -ForegroundColor Yellow
try {
    $frontend = Invoke-WebRequest -Uri "http://localhost:3000" -TimeoutSec 5 -ErrorAction Stop
    if ($frontend.StatusCode -eq 200) {
        Write-Host "  ✅ Frontend is accessible" -ForegroundColor Green
        Write-Host "     Status Code: $($frontend.StatusCode)" -ForegroundColor White
        Write-Host "     URL: http://localhost:3000" -ForegroundColor White
        $global:passedTests++
    }
} catch {
    Write-Host "  ❌ Frontend is NOT accessible" -ForegroundColor Red
    Write-Host "     Error: $($_.Exception.Message)" -ForegroundColor Red
    $global:failedTests++
}

Write-Host ""

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "PHASE 5: INTEGRATION TESTS" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

if ($allServicesHealthy) {
    Write-Host "Testing Service Integration..." -ForegroundColor Yellow
    
    # Test if API Gateway can reach all services
    Write-Host "  Gateway -> Product Service integration" -ForegroundColor Cyan
    $gatewayProducts = Test-Endpoint -Description "Products via Gateway" -Url "http://localhost:5000/api/v1/products"
    
    # Compare direct vs gateway access
    if ($products -and $gatewayProducts) {
        if ($products.total -eq $gatewayProducts.total) {
            Write-Host "    ✅ Gateway routing works correctly" -ForegroundColor Green
            $global:passedTests++
        } else {
            Write-Host "    ⚠️  Data mismatch between direct and gateway access" -ForegroundColor Yellow
        }
        $global:totalTests++
    }
}

Write-Host ""

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "TEST SUMMARY" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

$passPercentage = if ($totalTests -gt 0) { [math]::Round(($passedTests / $totalTests) * 100, 2) } else { 0 }

Write-Host "Total Tests: $totalTests" -ForegroundColor White
Write-Host "Passed: $passedTests" -ForegroundColor Green
Write-Host "Failed: $failedTests" -ForegroundColor Red
Write-Host "Success Rate: $passPercentage%" -ForegroundColor $(if ($passPercentage -ge 80) { "Green" } elseif ($passPercentage -ge 50) { "Yellow" } else { "Red" })
Write-Host ""

if ($passPercentage -eq 100) {
    Write-Host "🎉 ALL TESTS PASSED! System is fully operational!" -ForegroundColor Green
} elseif ($passPercentage -ge 80) {
    Write-Host "✅ Most tests passed. System is operational with minor issues." -ForegroundColor Yellow
} elseif ($passPercentage -ge 50) {
    Write-Host "⚠️  Some tests failed. System is partially operational." -ForegroundColor Yellow
} else {
    Write-Host "❌ Many tests failed. System needs attention." -ForegroundColor Red
}

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "SYSTEM ACCESS INFORMATION" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Frontend Application: http://localhost:3000" -ForegroundColor Green
Write-Host "API Gateway: http://localhost:5000" -ForegroundColor Cyan
Write-Host ""
Write-Host "Individual Services:" -ForegroundColor White
Write-Host "  - Product Service: http://localhost:5001" -ForegroundColor White
Write-Host "  - User Service: http://localhost:5002" -ForegroundColor White
Write-Host "  - Order Service: http://localhost:5003" -ForegroundColor White
Write-Host "  - Payment Service: http://localhost:5004" -ForegroundColor White
Write-Host "  - Notification Service: http://localhost:5005" -ForegroundColor White
Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
