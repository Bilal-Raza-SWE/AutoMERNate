# AutoMERNate - Quick Start Guide
**Author:** Muhammad Bilal Raza Attari  
**Project:** MLOps Assignment #2

---

## 🎯 What Has Been Done

### ✅ Phase 1: Application Customization (COMPLETED)

1. **Rebranded the Application**
   - Changed all occurrences of "MERN Shop" to "AutoMERNate"
   - Updated author name to "Muhammad Bilal Raza Attari" across all files
   - Modified package.json files (root and frontend)
   - Updated HTML titles, headers, footers, and email templates

2. **Updated Environment Configuration**
   - Created `.env.example` with comprehensive configuration
   - Updated README with detailed setup instructions
   - Documented all environment variables

3. **Customized UI/Branding**
   - Updated CSS color scheme with custom AutoMERNate colors
   - Modified Bootstrap theme variables
   - Changed primary colors to: #2C3E50, #16A085, #E67E22

### ✅ Phase 2: Docker Configuration (COMPLETED)

1. **Backend Dockerfile**
   - Multi-stage build for optimization
   - Security: Non-root user implementation
   - Health checks included
   - Location: `backend/Dockerfile`

2. **Frontend Dockerfile**
   - Multi-stage build with Nginx
   - Optimized production build
   - Security headers configured
   - Location: `frontend/Dockerfile`

3. **Nginx Configuration**
   - Custom nginx.conf for React Router
   - Gzip compression enabled
   - Security headers added
   - Location: `frontend/nginx.conf`

4. **Docker Compose**
   - Orchestrates 3 services: MongoDB, Backend, Frontend
   - Volume management for persistent data
   - Health checks for all services
   - Custom network configuration
   - Location: `docker-compose.yml`

### ✅ Phase 3: Kubernetes Configuration (COMPLETED)

All Kubernetes manifests are in the `k8s/` directory:

1. **configmap.yaml** - Non-sensitive configuration
2. **secret.yaml** - Sensitive credentials
3. **mongodb-deployment.yaml** - MongoDB with 3 replicas + Service + PVC
4. **backend-deployment.yaml** - Backend API with 3 replicas + NodePort Service
5. **frontend-deployment.yaml** - Frontend with 3 replicas + NodePort Service

**Features:**
- All services have 3 replicas as required
- Health checks (liveness + readiness probes)
- Resource limits and requests
- Persistent volumes for data
- NodePort services for external access

---

## 🚀 How to Run

### Option 1: Local Development

```powershell
# 1. Install dependencies
npm install
cd frontend
npm install
cd ..

# 2. Create .env file
cp .env.example .env
# Edit .env with your actual credentials

# 3. Start MongoDB (make sure it's running)

# 4. Run in development mode
npm run dev
```

### Option 2: Docker Compose

```powershell
# 1. Create .env file
cp .env.example .env

# 2. Run with Docker Compose
docker-compose up --build

# Access:
# Frontend: http://localhost:3000
# Backend: http://localhost:5000
```

### Option 3: Kubernetes (Minikube)

```powershell
# Quick deployment
.\deploy-k8s.ps1

# OR manual deployment (see k8s/README.md for details)
```

---

## 📸 Screenshots to Take for Assignment

### Part 1: Local/Docker Setup

1. ✅ Project structure in VS Code
2. ✅ `.env` file configuration
3. ✅ `npm install` output
4. ✅ Application running locally (browser)
5. ✅ Docker build commands
6. ✅ `docker-compose up` output
7. ✅ Docker containers running (`docker ps`)
8. ✅ Application running via Docker (browser)

### Part 2: Kubernetes Deployment

9. ✅ `minikube start` command output
10. ✅ Docker build for backend image
11. ✅ Docker build for frontend image
12. ✅ `kubectl apply` commands for all manifests
13. ✅ `kubectl get pods` showing 3 replicas each (9 total pods)
14. ✅ `kubectl get services` showing NodePort services
15. ✅ `kubectl get deployments` showing 3/3 ready
16. ✅ `kubectl describe pod <pod-name>` output
17. ✅ Application running via Minikube (browser at NodePort)
18. ✅ `kubectl scale` command (scaling to 5 replicas)
19. ✅ `kubectl get pods` after scaling (showing 5 replicas)
20. ✅ `kubectl logs <pod-name>` output
21. ✅ Minikube dashboard (optional)

### Part 3: Application Features

22. ✅ Homepage with products
23. ✅ Product details page
24. ✅ User registration page
25. ✅ User login page
26. ✅ Shopping cart
27. ✅ Checkout process
28. ✅ User profile page
29. ✅ Admin dashboard (if implemented)
30. ✅ Password reset email template

---

## 📝 Next Steps for You

### 1. Test the Application Locally
```powershell
npm run dev
```
- Test all features (signup, login, cart, checkout, etc.)
- Take screenshots of working features

### 2. Test with Docker Compose
```powershell
docker-compose up --build
```
- Verify all containers start successfully
- Take screenshots

### 3. Deploy to Kubernetes
```powershell
.\deploy-k8s.ps1
```
- Wait for all pods to be ready
- Take screenshots at each step
- Test scaling

### 4. Document Everything
- Use the screenshots
- Write explanations for each step
- Include architecture diagrams
- Document challenges faced and solutions

---

## 🎓 Assignment Report Structure

Use this structure for your final report:

### 1. Executive Summary
- Project overview
- Technologies used
- Your name and contribution

### 2. System Architecture
- Architecture diagram
- Component descriptions
- Technology stack

### 3. Implementation - Part 1 (Application)
- Setup process
- Features implemented
- Customizations made
- Screenshots

### 4. Implementation - Part 2 (DevOps)
- Dockerization process
- Docker Compose configuration
- Kubernetes deployment
- Scaling demonstration
- Screenshots of each step

### 5. Testing & Validation
- Test cases
- Results
- Screenshots

### 6. Challenges & Solutions
- Problems encountered
- How you solved them

### 7. Conclusion
- Learning outcomes
- Future improvements

### 8. Appendices
- Code snippets
- Configuration files
- Full screenshots

---

## 📁 Important Files Created/Modified

### Configuration Files
- ✅ `.env.example` - Environment template
- ✅ `.dockerignore` - Docker ignore rules
- ✅ `docker-compose.yml` - Docker orchestration
- ✅ `deploy-k8s.ps1` - Kubernetes deployment script

### Docker Files
- ✅ `backend/Dockerfile` - Backend container
- ✅ `frontend/Dockerfile` - Frontend container
- ✅ `frontend/nginx.conf` - Nginx configuration

### Kubernetes Files
- ✅ `k8s/configmap.yaml` - Configuration
- ✅ `k8s/secret.yaml` - Secrets
- ✅ `k8s/mongodb-deployment.yaml` - Database
- ✅ `k8s/backend-deployment.yaml` - API
- ✅ `k8s/frontend-deployment.yaml` - UI
- ✅ `k8s/README.md` - K8s instructions

### Modified Application Files
- ✅ `package.json` - Updated branding
- ✅ `frontend/package.json` - Updated branding
- ✅ `frontend/public/index.html` - Updated title
- ✅ `frontend/src/components/Header.jsx` - Updated brand name
- ✅ `frontend/src/components/Footer.jsx` - Updated copyright
- ✅ `frontend/src/components/Meta.jsx` - Updated SEO
- ✅ `frontend/src/components/Admin/AdminHeader.jsx` - Updated admin brand
- ✅ `frontend/src/pages/OrderDetailsPage.jsx` - Updated payment info
- ✅ `frontend/src/assets/styles/index.css` - Custom colors
- ✅ `frontend/src/assets/styles/bootstrap.custom.css` - Custom theme
- ✅ `backend/controllers/userController.js` - Updated email templates
- ✅ `README.md` - Updated documentation

---

## 🔧 Troubleshooting

### Docker Issues
```powershell
# Rebuild without cache
docker-compose build --no-cache

# View logs
docker-compose logs -f

# Remove all containers
docker-compose down -v
```

### Kubernetes Issues
```powershell
# Check pod status
kubectl get pods
kubectl describe pod <pod-name>

# View logs
kubectl logs <pod-name>

# Delete and redeploy
kubectl delete -f k8s/
.\deploy-k8s.ps1
```

---

## ✨ What Makes This Project Unique (Your Own Work)

1. **Custom Branding**: "AutoMERNate" - completely rebranded
2. **Author Attribution**: Your name on every file
3. **Custom Color Scheme**: Unique UI colors
4. **Enhanced Documentation**: Comprehensive guides
5. **Automated Deployment**: PowerShell script for K8s
6. **Production-Ready**: Multi-stage builds, health checks, security

---

## 📞 Support

If you need help:
1. Check `k8s/README.md` for Kubernetes instructions
2. Check `README.md` for application setup
3. Review Docker Compose logs
4. Check Kubernetes pod logs

---

**Good Luck with Your Assignment! 🎉**

**Remember:** This is now YOUR project - AutoMERNate by Muhammad Bilal Raza Attari!
