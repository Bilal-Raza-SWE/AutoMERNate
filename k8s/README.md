# AutoMERNate Kubernetes Deployment Instructions
# Author: Muhammad Bilal Raza Attari

## Prerequisites
- Docker Desktop installed and running
- Minikube installed
- kubectl installed

## Deployment Steps

### 1. Start Minikube
```powershell
minikube start --driver=docker --cpus=4 --memory=4096
```

### 2. Configure Docker to use Minikube's Docker daemon
```powershell
& minikube -p minikube docker-env --shell powershell | Invoke-Expression
```

### 3. Build Docker Images
```powershell
# Build backend image
docker build -t automernate-backend:latest -f backend/Dockerfile .

# Build frontend image
docker build -t automernate-frontend:latest -f frontend/Dockerfile ./frontend
```

### 4. Deploy to Kubernetes
```powershell
# Apply ConfigMap and Secrets
kubectl apply -f k8s/configmap.yaml
kubectl apply -f k8s/secret.yaml

# Deploy MongoDB
kubectl apply -f k8s/mongodb-deployment.yaml

# Deploy Backend
kubectl apply -f k8s/backend-deployment.yaml

# Deploy Frontend
kubectl apply -f k8s/frontend-deployment.yaml
```

### 5. Verify Deployment
```powershell
# Check all resources
kubectl get all -l app=automernate

# Check pods
kubectl get pods

# Check services
kubectl get services

# Check deployments
kubectl get deployments
```

### 6. Access the Application
```powershell
# Get Minikube IP
minikube ip

# Access URLs:
# Frontend: http://<minikube-ip>:30300
# Backend: http://<minikube-ip>:30500
```

## OR Use the Automated Script
```powershell
.\deploy-k8s.ps1
```

## Useful Commands

### Scaling
```powershell
# Scale backend to 5 replicas
kubectl scale deployment automernate-backend --replicas=5

# Scale frontend to 4 replicas
kubectl scale deployment automernate-frontend --replicas=4

# Scale MongoDB to 1 replica (recommended for development)
kubectl scale deployment automernate-mongodb --replicas=1
```

### Monitoring
```powershell
# View logs
kubectl logs -f deployment/automernate-backend
kubectl logs -f deployment/automernate-frontend

# Describe pod
kubectl describe pod <pod-name>

# Get pod details
kubectl get pod <pod-name> -o yaml
```

### Debugging
```powershell
# Execute command in pod
kubectl exec -it <pod-name> -- /bin/sh

# Port forward
kubectl port-forward deployment/automernate-backend 5000:5000
```

### Cleanup
```powershell
# Delete all resources
kubectl delete -f k8s/

# Or delete specific resources
kubectl delete deployment automernate-frontend
kubectl delete deployment automernate-backend
kubectl delete deployment automernate-mongodb
```

## Screenshot Checklist for Documentation

📸 **Take screenshots of:**

1. ✅ Minikube start command and output
2. ✅ Docker build commands for both images
3. ✅ kubectl apply commands
4. ✅ kubectl get pods (showing 3 replicas each)
5. ✅ kubectl get services (showing NodePort services)
6. ✅ kubectl get deployments (showing 3/3 ready)
7. ✅ Frontend application running in browser
8. ✅ Backend API response in browser/Postman
9. ✅ kubectl scale command (scaling to 5 replicas)
10. ✅ kubectl get pods (showing scaled replicas)
11. ✅ kubectl describe pod output
12. ✅ kubectl logs output
13. ✅ minikube dashboard (optional)

## Troubleshooting

### Pods not starting
```powershell
kubectl describe pod <pod-name>
kubectl logs <pod-name>
```

### Image pull errors
Make sure you're using Minikube's Docker daemon:
```powershell
& minikube -p minikube docker-env --shell powershell | Invoke-Expression
```

### Service not accessible
Check Minikube IP and NodePort:
```powershell
minikube ip
kubectl get service automernate-frontend-service
```
