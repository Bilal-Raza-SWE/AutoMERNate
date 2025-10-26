# 📸 Screenshot Collection Guide

This document lists all screenshots you need to capture for the final submission. Take these screenshots as you perform each step.

## Phase 1 — Docker & Dockerization

### Screenshot 00 — Environment Verification
**Command:**
```powershell
node -v; npm -v; docker --version; kubectl version --client; minikube version
```
**What to capture:** Terminal output showing all installed versions  
**Save as:** `fig00_environment_check.png`  
**Placement:** Section 4 (Environment & Prerequisites)

### Screenshot 01 — User Service Dockerfile
**Action:** Open `services/user-service/Dockerfile` in VS Code  
**What to capture:** Full Dockerfile with health check and bcrypt rebuild  
**Save as:** `fig01_user_dockerfile.png`  
**Placement:** Section 5A (Dockerfiles)

### Screenshot 02 — Frontend Multi-Stage Dockerfile
**Action:** Open `frontend/Dockerfile` in VS Code  
**What to capture:** Complete multi-stage build (builder + nginx stages)  
**Save as:** `fig02_frontend_dockerfile.png`  
**Placement:** Section 5B (Frontend Dockerfile)

### Screenshot 03 — Docker Build Output
**Command:**
```powershell
docker build -t automernate-user:dev ./services/user-service
```
**What to capture:** Build process output showing layers being created  
**Save as:** `fig03_docker_build_output.png`  
**Placement:** Section 5C (Build Images)

### Screenshot 04 — Docker Images List
**Command:**
```powershell
docker images | findstr automernate
```
**What to capture:** All 7 AutoMERNate images with tags and sizes  
**Save as:** `fig04_docker_images.png`  
**Placement:** Section 5C (After building all images)

---

## Phase 2 — Docker Compose

### Screenshot 05 — docker-compose.yml File
**Action:** Open `docker-compose.yml` in VS Code  
**What to capture:** Full file showing all 7 services, networks, health checks  
**Save as:** `fig05_docker_compose_yml.png`  
**Placement:** Section 6 (Docker Compose)

### Screenshot 06 — Docker Compose Up
**Command:**
```powershell
docker compose up -d
```
**What to capture:** Terminal showing all containers starting  
**Save as:** `fig06_docker_compose_up.png`  
**Placement:** Section 6 (Running Compose)

### Screenshot 07 — Docker PS (Running Containers)
**Command:**
```powershell
docker compose ps
```
**What to capture:** Status table showing all 7 containers healthy  
**Save as:** `fig07_docker_ps.png`  
**Placement:** Section 6 (Verify Containers)

### Screenshot 08 — Frontend in Browser (Docker Compose)
**Action:** Open http://localhost:3000 in browser  
**What to capture:** AutoMERNate homepage fully loaded  
**Save as:** `fig08_frontend_local.png`  
**Placement:** Section 6 (Testing)

---

## Phase 3 — Kubernetes (Minikube)

### Screenshot 09 — Minikube Start
**Command:**
```powershell
minikube start --driver=hyperv --cpus=4 --memory=8192
```
**What to capture:** Terminal showing Minikube starting and pulling images  
**Save as:** `fig09_minikube_start.png`  
**Placement:** Section 7.0 (Start Minikube)

### Screenshot 10 — Kubectl Version & Minikube Status
**Command:**
```powershell
kubectl version --client; minikube status
```
**What to capture:** Both outputs showing versions and running status  
**Save as:** `fig10_kubectl_status.png`  
**Placement:** Section 7.0 (Verify Setup)

### Screenshot 11 — Namespace Creation
**Command:**
```powershell
kubectl create namespace automernate
kubectl get namespaces
```
**What to capture:** Output showing automernate namespace created  
**Save as:** `fig11_namespace.png`  
**Placement:** Section 7.1 (Namespace)

### Screenshot 12 — Kubernetes Manifest (Example)
**Action:** Open `k8s/user-service.yaml` in VS Code  
**What to capture:** Full deployment + service YAML with 3 replicas  
**Save as:** `fig12_k8s_manifest.png`  
**Placement:** Section 7.2 (Manifests)

### Screenshot 13 — Apply Manifests
**Command:**
```powershell
kubectl apply -f k8s/ -n automernate
```
**What to capture:** Terminal showing all resources created/configured  
**Save as:** `fig13_kubectl_apply.png`  
**Placement:** Section 7.3 (Apply)

### Screenshot 14 — Get Pods (All Running)
**Command:**
```powershell
kubectl get pods -n automernate
```
**What to capture:** Pod list showing all replicas running (3 per service)  
**Save as:** `fig14_kubectl_pods.png`  
**Placement:** Section 7.3 (Verify Pods)

### Screenshot 15 — Get Services
**Command:**
```powershell
kubectl get svc -n automernate
```
**What to capture:** Service list with NodePort mappings  
**Save as:** `fig15_kubectl_services.png`  
**Placement:** Section 7.3 (Verify Services)

### Screenshot 16 — Frontend via Minikube IP
**Action:** Get Minikube IP and open frontend NodePort in browser  
**Command:**
```powershell
minikube ip
# Open http://<minikube-ip>:30003 in browser
```
**What to capture:** Browser showing AutoMERNate served from Kubernetes  
**Save as:** `fig16_frontend_minikube.png`  
**Placement:** Section 7.4 (Access Frontend)

---

## Phase 4 — Scaling & Validation

### Screenshot 17 — Scale Command
**Command:**
```powershell
kubectl scale deployment user-service --replicas=6 -n automernate
```
**What to capture:** Command output confirming scaling  
**Save as:** `fig17_kubectl_scale.png`  
**Placement:** Section 8 (Scaling)

### Screenshot 18 — Scaled Pods
**Command:**
```powershell
kubectl get pods -l app=user-service -n automernate
```
**What to capture:** 6 user-service pods running  
**Save as:** `fig18_scaled_pods.png`  
**Placement:** Section 8 (Verify Scaling)

### Screenshot 19 — Rollout Status
**Command:**
```powershell
kubectl rollout status deployment/user-service -n automernate
```
**What to capture:** Rollout completion message  
**Save as:** `fig19_rollout_status.png`  
**Placement:** Section 8 (Rollout)

---

## Phase 5 — Monitoring & Debugging

### Screenshot 20 — Minikube Dashboard
**Command:**
```powershell
minikube dashboard
```
**What to capture:** Dashboard overview showing all deployments, pods, services  
**Save as:** `fig20_minikube_dashboard.png`  
**Placement:** Section 9 (Monitoring)

### Screenshot 21 — Pod Logs
**Command:**
```powershell
kubectl logs <user-service-pod-name> -n automernate --tail=20
```
**What to capture:** Logs showing successful health checks and requests  
**Save as:** `fig21_kubectl_logs.png`  
**Placement:** Section 9 (Debugging)

### Screenshot 22 — Describe Pod
**Command:**
```powershell
kubectl describe pod <pod-name> -n automernate
```
**What to capture:** Pod details showing events, status, and conditions  
**Save as:** `fig22_describe_pod.png`  
**Placement:** Section 9 (Troubleshooting)

---

## Optional — CI/CD

### Screenshot 23 — GitHub Actions Workflow File
**Action:** Open `.github/workflows/ci-cd.yml` in VS Code  
**What to capture:** Complete CI/CD workflow YAML  
**Save as:** `fig23_github_actions.png`  
**Placement:** Section 10 (CI/CD)

### Screenshot 24 — GitHub Actions Run
**Action:** Navigate to GitHub Actions tab after pushing  
**What to capture:** Successful workflow run with all green checkmarks  
**Save as:** `fig24_actions_success.png`  
**Placement:** Section 10 (CI/CD Execution)

---

## Summary Checklist

Before final submission, ensure you have:

- [ ] All 24 screenshots captured and named correctly
- [ ] Screenshots placed in a `screenshots/` folder in the repo
- [ ] Each screenshot placeholder in `FINAL_SUBMISSION.md` replaced with the actual image path
- [ ] High-quality screenshots (clear text, no truncation)
- [ ] Consistent screenshot format (PNG recommended)

## Tips for Good Screenshots

1. **Use full terminal window** — Don't crop important output
2. **Increase terminal font size** for readability (14-16pt recommended)
3. **Use a clean theme** — Light backgrounds work better in print documents
4. **Wait for commands to complete** before screenshotting
5. **Highlight important sections** if needed (using red boxes or arrows)
6. **Include timestamps** where relevant to show real execution
7. **Capture browser DevTools** (F12) for frontend screenshots to show network requests

---

## Example: Embedding in Word Document

In your final Word document, insert images like this:

```
Figure 01 — User Service Dockerfile
[Insert fig01_user_dockerfile.png here]

The Dockerfile shows a multi-stage approach with health checks enabled...
```

Good luck with your screenshots! 📸
