# AutoMERNate - Stop All Running Services
# Author: Muhammad Bilal Raza Attari

Write-Host "🛑 Stopping all AutoMERNate services..." -ForegroundColor Yellow

# Stop Node.js processes on specific ports
$ports = @(5000, 5001, 5002, 5003, 5004, 5005, 3000)

foreach ($port in $ports) {
    Write-Host "Checking port $port..." -ForegroundColor Cyan
    
    # Find processes using the port
    $processInfo = netstat -ano | findstr ":$port"
    
    if ($processInfo) {
        # Extract PID (last column)
        $processInfo -split "`n" | ForEach-Object {
            if ($_ -match "\s+(\d+)\s*$") {
                $pid = $matches[1]
                try {
                    Stop-Process -Id $pid -Force -ErrorAction SilentlyContinue
                    Write-Host "  ✅ Stopped process on port $port (PID: $pid)" -ForegroundColor Green
                } catch {
                    Write-Host "  ⚠️  Could not stop process $pid" -ForegroundColor Yellow
                }
            }
        }
    } else {
        Write-Host "  ℹ️  No process running on port $port" -ForegroundColor Gray
    }
}

Write-Host ""
Write-Host "✅ All services stopped!" -ForegroundColor Green
Write-Host "You can now start them again individually or use start-all-services.ps1" -ForegroundColor Cyan
