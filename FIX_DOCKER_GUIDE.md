# Docker Virtual Machine Platform Fix - Quick Guide

## Problem
Docker Desktop shows: "Virtual Machine Platform not enabled"

## Solution Steps

### Step 1: Enable Virtual Machine Platform

**Option A: PowerShell (Administrator)**
```powershell
# Open PowerShell as Administrator and run:
Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -NoRestart
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -NoRestart
```

**Option B: Windows Settings**
1. Settings → Apps → Optional Features → More Windows Features
2. Enable:
   - ☑ Virtual Machine Platform
   - ☑ Windows Subsystem for Linux
   - ☑ Hyper-V (if available)
3. Click OK

### Step 2: Restart Computer
**IMPORTANT**: You MUST restart your computer for changes to take effect.

### Step 3: After Restart

1. Start Docker Desktop
2. Wait for Docker to fully start (whale icon in system tray)
3. Verify Docker is working:
   ```powershell
   docker --version
   docker ps
   ```

---

## After Docker is Fixed - Run AutoMERNate

Once Docker is working, run the system:

### Method 1: Automated Setup (Recommended)
```powershell
.\setup-and-run.ps1
```
This will guide you through:
- Choosing Docker/Local/Kubernetes mode
- Installing dependencies
- Starting all services
- Testing the system

### Method 2: Docker Compose (Quick Start)
```powershell
# Make sure .env file exists
docker-compose -f docker-compose-microservices.yml up --build
```

### Method 3: Local Development
```powershell
.\start-all-services.ps1
```

### Test the System
```powershell
.\test-complete-system.ps1
```

---

## Expected Results

After successful setup:
- ✅ Frontend: http://localhost:3000
- ✅ API Gateway: http://localhost:5000
- ✅ Product Service: http://localhost:5001
- ✅ User Service: http://localhost:5002
- ✅ Order Service: http://localhost:5003
- ✅ Payment Service: http://localhost:5004
- ✅ Notification Service: http://localhost:5005

---

## Troubleshooting

**If Docker still doesn't work after restart:**

1. Check Windows version (requires Windows 10 Pro/Enterprise/Education or Windows 11)
2. Enable Virtualization in BIOS:
   - Restart computer
   - Enter BIOS (usually F2, F10, or Del key)
   - Find "Virtualization Technology" or "Intel VT-x" or "AMD-V"
   - Enable it
   - Save and exit

3. Check Hyper-V status:
   ```powershell
   Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V
   ```

**If you prefer not to use Docker:**

Run the system locally without Docker:
```powershell
.\setup-and-run.ps1
# Choose option 2 (Local Development)
```

---

## Architecture Confirmation

**AutoMERNate is a MICROSERVICES Architecture:**

✅ 6 Independent Services:
- Product Service (Port 5001)
- User Service (Port 5002)  
- Order Service (Port 5003)
- Payment Service (Port 5004)
- Notification Service (Port 5005)
- API Gateway (Port 5000)

✅ Frontend (Port 3000)

✅ Each service can be:
- Deployed independently
- Scaled independently
- Has its own database connection
- Communicates via REST APIs

NOT Monolithic ❌
NOT Hybrid ❌
PURE Microservices ✅
