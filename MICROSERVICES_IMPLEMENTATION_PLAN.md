# 🏗️ AutoMERNate Microservices Architecture Implementation Plan
## Author: Muhammad Bilal Raza Attari
## Complete Step-by-Step Guide for MLOps Assignment #2

---

## ✅ COMPLETED WORK

### 1. Product Service (Port 5001) - ✅ RUNNING
- ✅ Created `services/product-service/` directory structure
- ✅ Created `package.json` with dependencies
- ✅ Created `server.js` with Express and MongoDB connection
- ✅ Created `models/productModel.js` with Product and Review schemas
- ✅ Created `controllers/productController.js` with 7 endpoints:
  - GET `/api/v1/products` - Get all products (with pagination & search)
  - GET `/api/v1/products/top` - Get top-rated products
  - GET `/api/v1/products/:id` - Get single product
  - POST `/api/v1/products` - Create product (admin)
  - PUT `/api/v1/products/:id` - Update product (admin)
  - DELETE `/api/v1/products/:id` - Delete product (admin)
  - POST `/api/v1/products/reviews/:id` - Add product review
- ✅ Created `routes/productRoutes.js`
- ✅ Created `middleware/errorMiddleware.js`
- ✅ Created `Dockerfile`
- ✅ Created `.env` file with MongoDB Atlas connection
- ✅ Installed dependencies (`npm install`)
- ✅ **SERVICE IS RUNNING on port 5001**

**Test Product Service:**
```powershell
# Check health
Invoke-RestMethod -Uri http://localhost:5001/health

# Get all products
Invoke-RestMethod -Uri http://localhost:5001/api/v1/products
```

---

## 🚧 REMAINING WORK

### 2. User Service (Port 5002) - NOT STARTED
**Purpose:** Handle user authentication, registration, JWT tokens

**Files to Create:**
```
services/user-service/
├── package.json
├── server.js
├── .env
├── Dockerfile
├── models/
│   └── userModel.js
├── controllers/
│   └── userController.js
├── routes/
│   └── userRoutes.js
├── middleware/
│   ├── authMiddleware.js (protect, admin)
│   └── errorMiddleware.js
└── utils/
    └── generateToken.js
```

**Endpoints:**
- POST `/api/v1/users/register` - Register new user
- POST `/api/v1/users/login` - Login user (returns JWT)
- GET `/api/v1/users/profile` - Get user profile (protected)
- PUT `/api/v1/users/profile` - Update user profile (protected)
- GET `/api/v1/users` - Get all users (admin)
- GET `/api/v1/users/:id` - Get user by ID (admin)
- PUT `/api/v1/users/:id` - Update user (admin)
- DELETE `/api/v1/users/:id` - Delete user (admin)

**Steps:**
1. Copy from `backend/models/userModel.js`
2. Copy from `backend/controllers/userController.js`
3. Copy from `backend/routes/userRoutes.js`
4. Copy from `backend/middleware/authMiddleware.js`
5. Copy from `backend/utils/generateToken.js`
6. Create `package.json` with dependencies: express, mongoose, bcryptjs, jsonwebtoken, dotenv, cors
7. Create `server.js` on port 5002
8. Create `.env` with MONGO_URI and JWT_SECRET
9. Create `Dockerfile`
10. `npm install && npm start`

---

### 3. Order Service (Port 5003) - NOT STARTED
**Purpose:** Handle order creation, tracking, and management

**Files to Create:**
```
services/order-service/
├── package.json
├── server.js
├── .env
├── Dockerfile
├── models/
│   └── orderModel.js
├── controllers/
│   └── orderController.js
├── routes/
│   └── orderRoutes.js
└── middleware/
    └── errorMiddleware.js
```

**Endpoints:**
- POST `/api/v1/orders` - Create order (protected)
- GET `/api/v1/orders/myorders` - Get user's orders (protected)
- GET `/api/v1/orders/:id` - Get order by ID (protected)
- PUT `/api/v1/orders/:id/pay` - Mark order as paid (protected)
- PUT `/api/v1/orders/:id/deliver` - Mark order as delivered (admin)
- GET `/api/v1/orders` - Get all orders (admin)

**Inter-Service Communication:**
- Call User Service to verify JWT tokens
- Call Product Service to check product availability and update stock

**Steps:**
1. Copy from `backend/models/orderModel.js`
2. Copy from `backend/controllers/orderController.js`
3. Copy from `backend/routes/orderRoutes.js`
4. Create `package.json` with dependencies: express, mongoose, dotenv, cors, axios (for API calls)
5. Create `server.js` on port 5003
6. Add HTTP client to call Product Service and User Service
7. Create `.env`
8. Create `Dockerfile`
9. `npm install && npm start`

---

### 4. Payment Service (Port 5004) - NOT STARTED
**Purpose:** Handle Razorpay payment integration

**Files to Create:**
```
services/payment-service/
├── package.json
├── server.js
├── .env
├── Dockerfile
├── controllers/
│   └── paymentController.js
└── routes/
    └── paymentRoutes.js
```

**Endpoints:**
- GET `/api/v1/payment/key` - Get Razorpay key
- POST `/api/v1/payment/razorpay` - Create Razorpay order

**Steps:**
1. Copy from `backend/controllers/paymentController.js`
2. Copy from `backend/routes/paymentRoutes.js`
3. Create `package.json` with dependencies: express, razorpay, dotenv, cors
4. Create `server.js` on port 5004
5. Create `.env` with RAZORPAY_KEY_ID and RAZORPAY_KEY_SECRET
6. Create `Dockerfile`
7. `npm install && npm start`

---

### 5. API Gateway (Port 5000) - NOT STARTED
**Purpose:** Route requests from frontend to appropriate microservices

**Files to Create:**
```
services/api-gateway/
├── package.json
├── server.js
├── .env
└── Dockerfile
```

**Routing Logic:**
- `/api/v1/products/*` → Product Service (5001)
- `/api/v1/users/*` → User Service (5002)
- `/api/v1/orders/*` → Order Service (5003)
- `/api/v1/payment/*` → Payment Service (5004)

**Implementation:**
```javascript
import express from 'express';
import { createProxyMiddleware } from 'http-proxy-middleware';
import cors from 'cors';

const app = express();
app.use(cors());
app.use(express.json());

// Route to Product Service
app.use('/api/v1/products', createProxyMiddleware({ 
  target: process.env.PRODUCT_SERVICE_URL || 'http://localhost:5001',
  changeOrigin: true 
}));

// Route to User Service
app.use('/api/v1/users', createProxyMiddleware({ 
  target: process.env.USER_SERVICE_URL || 'http://localhost:5002',
  changeOrigin: true 
}));

// Route to Order Service
app.use('/api/v1/orders', createProxyMiddleware({ 
  target: process.env.ORDER_SERVICE_URL || 'http://localhost:5003',
  changeOrigin: true 
}));

// Route to Payment Service
app.use('/api/v1/payment', createProxyMiddleware({ 
  target: process.env.PAYMENT_SERVICE_URL || 'http://localhost:5004',
  changeOrigin: true 
}));

app.listen(5000, () => console.log('🚪 API Gateway running on port 5000'));
```

**package.json dependencies:**
- express
- http-proxy-middleware
- cors
- dotenv

**Steps:**
1. Create `package.json`
2. Create `server.js` with proxy routing
3. Create `.env` with service URLs
4. Create `Dockerfile`
5. `npm install && npm start`

---

### 6. Update Frontend - NOT STARTED
**Purpose:** Point API calls to API Gateway instead of direct backend

**Current:** Frontend calls `http://localhost:5000/api/...`
**Target:** Frontend still calls `http://localhost:5000/api/...` (Gateway will route)

Since API Gateway runs on port 5000, **NO CHANGES NEEDED** in frontend! ✅

---

### 7. Docker Compose Rewrite - NOT STARTED
**Purpose:** Run all 6 services in containers

**New `docker-compose.yml`:**
```yaml
version: '3.8'

services:
  # Product Service
  product-service:
    build:
      context: ./services/product-service
      dockerfile: Dockerfile
    ports:
      - "5001:5001"
    environment:
      - NODE_ENV=production
      - MONGO_URI=${MONGO_URI}
      - PRODUCT_SERVICE_PORT=5001
    networks:
      - automernate-network

  # User Service
  user-service:
    build:
      context: ./services/user-service
      dockerfile: Dockerfile
    ports:
      - "5002:5002"
    environment:
      - NODE_ENV=production
      - MONGO_URI=${MONGO_URI}
      - JWT_SECRET=${JWT_SECRET}
      - USER_SERVICE_PORT=5002
    networks:
      - automernate-network

  # Order Service
  order-service:
    build:
      context: ./services/order-service
      dockerfile: Dockerfile
    ports:
      - "5003:5003"
    environment:
      - NODE_ENV=production
      - MONGO_URI=${MONGO_URI}
      - ORDER_SERVICE_PORT=5003
      - PRODUCT_SERVICE_URL=http://product-service:5001
      - USER_SERVICE_URL=http://user-service:5002
    depends_on:
      - product-service
      - user-service
    networks:
      - automernate-network

  # Payment Service
  payment-service:
    build:
      context: ./services/payment-service
      dockerfile: Dockerfile
    ports:
      - "5004:5004"
    environment:
      - NODE_ENV=production
      - PAYMENT_SERVICE_PORT=5004
      - RAZORPAY_KEY_ID=${RAZORPAY_KEY_ID}
      - RAZORPAY_KEY_SECRET=${RAZORPAY_KEY_SECRET}
    networks:
      - automernate-network

  # API Gateway
  api-gateway:
    build:
      context: ./services/api-gateway
      dockerfile: Dockerfile
    ports:
      - "5000:5000"
    environment:
      - NODE_ENV=production
      - PRODUCT_SERVICE_URL=http://product-service:5001
      - USER_SERVICE_URL=http://user-service:5002
      - ORDER_SERVICE_URL=http://order-service:5003
      - PAYMENT_SERVICE_URL=http://payment-service:5004
    depends_on:
      - product-service
      - user-service
      - order-service
      - payment-service
    networks:
      - automernate-network

  # Frontend
  frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile
    ports:
      - "3000:80"
    depends_on:
      - api-gateway
    networks:
      - automernate-network

networks:
  automernate-network:
    driver: bridge
```

**Steps:**
1. Backup old `docker-compose.yml`
2. Create new `docker-compose.yml` with 6 services
3. Test: `docker-compose up --build`

---

### 8. Kubernetes Manifests Rewrite - NOT STARTED
**Purpose:** Deploy to Kubernetes with 3 replicas per service

**Files to Create:**
```
k8s/
├── product-service-deployment.yaml (3 replicas)
├── user-service-deployment.yaml (3 replicas)
├── order-service-deployment.yaml (3 replicas)
├── payment-service-deployment.yaml (3 replicas)
├── api-gateway-deployment.yaml (3 replicas)
├── frontend-deployment.yaml (3 replicas)
├── configmap.yaml (updated)
└── secret.yaml (updated)
```

**Example: `product-service-deployment.yaml`:**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: product-service
spec:
  replicas: 3
  selector:
    matchLabels:
      app: product-service
  template:
    metadata:
      labels:
        app: product-service
    spec:
      containers:
      - name: product-service
        image: bilalrazaswe/automernate-product-service:latest
        ports:
        - containerPort: 5001
        env:
        - name: MONGO_URI
          valueFrom:
            secretKeyRef:
              name: automernate-secret
              key: mongo-uri
        - name: PRODUCT_SERVICE_PORT
          value: "5001"
---
apiVersion: v1
kind: Service
metadata:
  name: product-service
spec:
  type: NodePort
  selector:
    app: product-service
  ports:
  - port: 5001
    targetPort: 5001
    nodePort: 30001
```

**Repeat for all 5 backend services + frontend**

**Steps:**
1. Create deployment YAML for each service
2. Update ConfigMap and Secret
3. `kubectl apply -f k8s/`
4. Verify: `kubectl get pods` (should show 18 pods = 6 services × 3 replicas)
5. Verify: `kubectl get services`

---

## 📋 EXECUTION CHECKLIST

### Phase 1: Build Remaining Microservices
- [ ] Create User Service (1 hour)
- [ ] Test User Service endpoints
- [ ] Create Order Service (1 hour)
- [ ] Test Order Service endpoints
- [ ] Create Payment Service (30 minutes)
- [ ] Test Payment Service endpoints
- [ ] Create API Gateway (30 minutes)
- [ ] Test API Gateway routing

### Phase 2: Containerization
- [ ] Build Docker image for each service
- [ ] Test individual containers
- [ ] Create new `docker-compose.yml`
- [ ] `docker-compose up --build`
- [ ] Verify all 6 services running

### Phase 3: Kubernetes Deployment
- [ ] Create 6 deployment YAMLs
- [ ] Create 6 service YAMLs
- [ ] Update ConfigMap
- [ ] Update Secret
- [ ] `kubectl apply -f k8s/`
- [ ] Verify 18 pods running (3 replicas × 6 services)
- [ ] Test application through Minikube IP

### Phase 4: Documentation & Screenshots
- [ ] Architecture diagram
- [ ] `docker ps` screenshot
- [ ] `kubectl get pods` screenshot
- [ ] `kubectl get services` screenshot
- [ ] Application screenshots (registration, login, products, cart, checkout)
- [ ] Update MLOPS_ASSIGNMENT_GUIDE.md

---

## 🎯 NEXT STEPS

### Immediate Action (Now):
1. Create **User Service** (highest priority - other services depend on it for auth)
2. Create **Order Service**
3. Create **Payment Service**
4. Create **API Gateway**
5. Test all services locally
6. Rewrite `docker-compose.yml`
7. Rewrite Kubernetes manifests
8. Deploy and test

### Time Estimate:
- User Service: 1 hour
- Order Service: 1 hour
- Payment Service: 30 minutes
- API Gateway: 30 minutes
- Docker Compose: 30 minutes
- Kubernetes: 1 hour
- Testing: 1 hour
- **Total: ~5-6 hours of focused work**

---

## ✅ SUCCESS CRITERIA

Your assignment will be complete when:
1. ✅ All 5 backend microservices running independently
2. ✅ API Gateway routing requests correctly
3. ✅ Frontend connecting through API Gateway
4. ✅ All services containerized with Docker
5. ✅ All services deployed to Kubernetes with 3 replicas each
6. ✅ `kubectl get pods` shows 18 running pods
7. ✅ Application fully functional end-to-end
8. ✅ Screenshots captured for documentation

---

**Author:** Muhammad Bilal Raza Attari  
**Project:** AutoMERNate - MERN E-Commerce Platform  
**Architecture:** True Microservices (Product, User, Order, Payment, API Gateway, Frontend)  
**Deployment:** Docker + Kubernetes (Minikube)

