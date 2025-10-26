# 🛍️ AutoMERNate

### Enterprise-Grade Microservices E-Commerce Platform

[![MERN Stack](https://img.shields.io/badge/Stack-MERN-green?style=for-the-badge&logo=mongodb&logoColor=white)](https://github.com/Bilal-Raza-SWE/automernate)[![Microservices](https://img.shields.io/badge/Architecture-Microservices-blue?style=for-the-badge&logo=kubernetes&logoColor=white)](https://kubernetes.io/)[![Docker](https://img.shields.io/badge/Docker-Ready-2496ED?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com/)[![Kubernetes](https://img.shields.io/badge/Kubernetes-Deployed-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)](https://kubernetes.io/)[![MLOps](https://img.shields.io/badge/MLOps-Assignment_02-orange?style=for-the-badge)](https://github.com/Bilal-Raza-SWE/automernate)

**Author:** Muhammad Bilal Raza Attari 

---

### 📋 Quick Links

[Features](#-features) • [Architecture](#-architecture) • [Tech Stack](#-tech-stack) • [Quick Start](#-quick-start) • [Docker](#-docker-deployment) • [Kubernetes](#-kubernetes-deployment) • [Documentation](#-documentation)

---

## 🎯 Overview

**AutoMERNate** is a production-ready, cloud-native e-commerce platform built with **pure microservices architecture**. Originally a monolithic MERN application, it has been completely restructured into 7 independent, containerized microservices that can be deployed, scaled, and managed independently.

> 💡 **Perfect for:** MLOps assignments, DevOps demonstrations, microservices learning, and production e-commerce deployments.

---

## 🏗️ Architecture

AutoMERNate follows a **domain-driven microservices architecture** with complete service isolation:

```
┌─────────────────────────────────────────────────────────────┐│                        Frontend (React)                      ││                     Nginx Reverse Proxy                      │└────────────────────────┬────────────────────────────────────┘                         │                         ▼┌─────────────────────────────────────────────────────────────┐│                    API Gateway (Port 5000)                   ││              Request Routing & Load Balancing                │└─────┬──────┬──────┬──────┬──────┬─────────────────────────┘      │      │      │      │      │      ▼      ▼      ▼      ▼      ▼┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────────────┐│ Product │ │  User   │ │  Order  │ │ Payment │ │  Notification   ││ Service │ │ Service │ │ Service │ │ Service │ │    Service      ││ :5001   │ │ :5002   │ │ :5003   │ │ :5004   │ │    :5005        │└─────────┘ └─────────┘ └─────────┘ └─────────┘ └─────────────────┘     │           │           │           │              │     └───────────┴───────────┴───────────┴──────────────┘                         │                         ▼              ┌──────────────────────┐              │   MongoDB Atlas      │              │ (Isolated Databases) │              └──────────────────────┘
```

### 🔧 Microservices Breakdown

Service

Port

Responsibility

Database

**🎨 Frontend**

3000/80

React SPA, User Interface

**🚪 API Gateway**

5000

Request routing, Load balancing

**📦 Product Service**

5001

Product catalog, inventory, reviews

MongoDB (products)

**👤 User Service**

5002

Authentication, user profiles, JWT

MongoDB (users)

**🛒 Order Service**

5003

Shopping cart, order processing

MongoDB (orders)

**💳 Payment Service**

5004

Razorpay integration, transactions

MongoDB (payments)

**📧 Notification Service**

5005

Email notifications, alerts

MongoDB (notifications)

### 🎯 Key Architectural Principles

-   ✅ **Service Independence**: Each service can be developed, deployed, and scaled independently
-   ✅ **Database Per Service**: No shared databases - complete data isolation
-   ✅ **API-First Design**: RESTful APIs for all inter-service communication
-   ✅ **Containerization**: All services are Docker-ready with health checks
-   ✅ **Cloud Native**: Kubernetes manifests for orchestration and scaling
-   ✅ **DevOps Ready**: CI/CD pipelines, monitoring, and logging configured

---

## ✨ Features

---

### 🛒 Customer Features

-   ✅ **Full-Featured Shopping Cart** - Add, remove, update quantities with real-time total
-   ✅ **Product Reviews & Ratings** - User-generated reviews with 5-star rating system
-   ✅ **Product Search & Filters** - Advanced search with category and price filters
-   ✅ **Product Pagination** - Efficient browsing with server-side pagination
-   ✅ **User Profiles** - Manage personal information and view order history
-   ✅ **Secure Checkout** - Multi-step checkout with shipping and payment options
-   ✅ **Payment Integration** - Razorpay for secure credit/debit card payments
-   ✅ **Order Tracking** - Real-time order status updates
-   ✅ **Email Notifications** - Order confirmations and updates via email

### 👨‍💼 Admin Features

-   ✅ **Comprehensive Dashboard** - Overview of orders, products, users, and revenue
-   ✅ **Product Management** - CRUD operations for product catalog
-   ✅ **User Management** - Manage customer accounts and permissions
-   ✅ **Order Management** - View, process, and update order statuses
-   ✅ **Admin Management** - Create and manage admin accounts
-   ✅ **Database Seeder** - Populate database with sample data for testing

### 🚀 DevOps & MLOps Features

-   ✅ **Containerization** - Docker images for all services with health checks
-   ✅ **Orchestration** - Kubernetes manifests with ConfigMaps and Secrets
-   ✅ **Horizontal Scaling** - Scale services independently based on load
-   ✅ **Service Discovery** - Automatic service registration and discovery
-   ✅ **CI/CD Ready** - GitHub Actions workflows for automated deployment
-   ✅ **Monitoring** - Health checks and logging for all services
-   ✅ **Environment Management** - Separate configs for dev, staging, production

---

## 🛠️ Tech Stack

### Frontend

-   **React.js** - Component-based UI library
-   **Redux Toolkit** - State management
-   **React Router** - Client-side routing
-   **Axios** - HTTP client for API calls
-   **React Bootstrap** - UI components and styling
-   **Nginx** - Production web server

### Backend

-   **Node.js** - JavaScript runtime
-   **Express.js** - Web application framework
-   **MongoDB** - NoSQL database (MongoDB Atlas)
-   **Mongoose** - ODM for MongoDB
-   **JWT** - JSON Web Tokens for authentication
-   **Bcrypt** - Password hashing
-   **Razorpay** - Payment gateway integration
-   **Nodemailer** - Email service

### DevOps & Infrastructure

-   **Docker** - Containerization platform
-   **Docker Compose** - Multi-container orchestration
-   **Kubernetes** - Container orchestration
-   **Minikube** - Local Kubernetes cluster
-   **GitHub Actions** - CI/CD pipelines
-   **MongoDB Atlas** - Cloud database

---

## 🚀 Quick Start

### Prerequisites

Ensure you have the following installed:

-   **Node.js** (v18 or higher) - [Download here](https://nodejs.org/)
-   **MongoDB** - Either local installation or [MongoDB Atlas](https://www.mongodb.com/cloud/atlas) account
-   **Git** - For cloning the repository
-   **Razorpay Account** - For payment integration ([Sign up](https://razorpay.com/))
-   **Gmail Account** - For email services with App Password enabled

### 📥 Installation Steps

1.  **Clone the Repository**

```bash
git clone https://github.com/Bilal-Raza-SWE/automernate.gitcd automernate
```

2.  **Install Dependencies**

```bash
# Install root dependenciesnpm install# Install frontend dependenciescd frontendnpm installcd ..# Install service dependenciescd services/api-gateway && npm install && cd ../..cd services/product-service && npm install && cd ../..cd services/user-service && npm install && cd ../..cd services/order-service && npm install && cd ../..cd services/payment-service && npm install && cd ../..cd services/notification-service && npm install && cd ../..
```

3.  **Configure Environment Variables**

Create a `.env` file in the root directory:

```env
# ApplicationNODE_ENV=developmentPORT=5000# DatabaseMONGO_URI=mongodb+srv://your_username:your_password@cluster.mongodb.net/automernate?retryWrites=true&w=majority# JWTJWT_SECRET=your_jwt_secret_key_here# Razorpay (Payment Gateway)RAZORPAY_KEY_ID=your_razorpay_key_idRAZORPAY_KEY_SECRET=your_razorpay_key_secret# Email Configuration (Gmail SMTP)EMAIL_HOST=smtp.gmail.comEMAIL_PORT=587EMAIL_USER=your_email@gmail.comEMAIL_PASS=your_app_specific_password# FrontendREACT_APP_API_URL=http://localhost:5000
```

**📧 Gmail App Password Setup:**

1.  Enable 2-Factor Authentication in your Google Account
    
2.  Go to Google Account → Security → 2-Step Verification → App Passwords
    
3.  Generate a new app password for "Mail"
    
4.  Use this password in `EMAIL_PASS`
    
5.  **Seed the Database (Optional)**
    

```bash
# Import sample products and usersnpm run data:import# Destroy all datanpm run data:destroy
```

5.  **Start the Application**

**Option A: Development Mode (Separate Terminals)**

```bash
# Terminal 1: Start API Gatewaycd services/api-gatewaynpm run dev# Terminal 2: Start Product Servicecd services/product-servicenpm run dev# Terminal 3: Start User Servicecd services/user-servicenpm run dev# Terminal 4: Start Order Servicecd services/order-servicenpm run dev# Terminal 5: Start Payment Servicecd services/payment-servicenpm run dev# Terminal 6: Start Notification Servicecd services/notification-servicenpm run dev# Terminal 7: Start Frontendcd frontendnpm start
```

**Option B: Using PowerShell Script (Windows)**

```powershell
.start-all-services.ps1
```

6.  **Access the Application**

-   **Frontend**: `http://localhost:3000`
-   **API Gateway**: `http://localhost:5000`
-   **Product Service**: `http://localhost:5001`
-   **User Service**: `http://localhost:5002`
-   **Order Service**: `http://localhost:5003`
-   **Payment Service**: `http://localhost:5004`
-   **Notification Service**: `http://localhost:5005`

---

## 🐳 Docker Deployment

### Build Docker Images

Build all service images:

```bash
# Frontenddocker build -t automernate-frontend:dev ./frontend# API Gatewaydocker build -t automernate-api-gateway:dev ./services/api-gateway# Microservicesdocker build -t automernate-product:dev ./services/product-servicedocker build -t automernate-user:dev ./services/user-servicedocker build -t automernate-order:dev ./services/order-servicedocker build -t automernate-payment:dev ./services/payment-servicedocker build -t automernate-notification:dev ./services/notification-service
```

**Or use the PowerShell script:**

```powershell
.build-docker-images.ps1
```

### Run with Docker Compose

Start all services using Docker Compose:

```bash
# Start all containersdocker compose -f docker-compose-microservices.yml up -d# View running containersdocker compose ps# View logsdocker compose logs -f# Stop all containersdocker compose down
```

### Docker Image Sizes

Image

Size

Base Image

automernate-frontend

~98 MB

node:18-alpine → nginx:alpine

automernate-api-gateway

~200 MB

node:18-alpine

automernate-product

~250 MB

node:18-alpine

automernate-user

~280 MB

node:18-alpine

automernate-order

~240 MB

node:18-alpine

automernate-payment

~220 MB

node:18-alpine

automernate-notification

~210 MB

node:18-alpine

### Health Checks

All backend services include health check endpoints:

```bash
# Check service healthcurl http://localhost:5001/health  # Product Servicecurl http://localhost:5002/health  # User Servicecurl http://localhost:5003/health  # Order Servicecurl http://localhost:5004/health  # Payment Servicecurl http://localhost:5005/health  # Notification Service
```

---

## ☸️ Kubernetes Deployment

### Prerequisites

-   **Minikube** installed ([Installation Guide](https://minikube.sigs.k8s.io/docs/start/))
-   **kubectl** installed ([Installation Guide](https://kubernetes.io/docs/tasks/tools/))
-   Docker images built locally

### Start Minikube

```bash
# Start Minikube with adequate resourcesminikube start --driver=docker --cpus=4 --memory=6144# Verify Minikube is runningminikube status# Enable dashboard (optional)minikube dashboard
```

### Load Docker Images into Minikube

```bash
# Load all images into Minikube's Docker environmentminikube image load automernate-frontend:devminikube image load automernate-api-gateway:devminikube image load automernate-product:devminikube image load automernate-user:devminikube image load automernate-order:devminikube image load automernate-payment:devminikube image load automernate-notification:dev# Verify images are loadedminikube image ls | grep automernate
```

### Deploy to Kubernetes

```bash
# Create namespacekubectl create namespace automernate# Apply configurationskubectl apply -f k8s/secret.yamlkubectl apply -f k8s/configmap-microservices.yaml# Deploy all serviceskubectl apply -f k8s/product-service.yaml -n automernatekubectl apply -f k8s/user-service.yaml -n automernatekubectl apply -f k8s/order-service.yaml -n automernatekubectl apply -f k8s/payment-service.yaml -n automernatekubectl apply -f k8s/notification-service.yaml -n automernatekubectl apply -f k8s/api-gateway.yaml -n automernatekubectl apply -f k8s/frontend.yaml -n automernate# Verify deploymentskubectl get pods -n automernatekubectl get svc -n automernate
```

**Or use the PowerShell script:**

```powershell
.deploy-k8s-microservices.ps1
```

### Access Services

Get the Minikube IP and access services via NodePort:

```bash
# Get Minikube IPminikube ip# Access frontendminikube service frontend -n automernate# Access API Gatewayminikube service api-gateway -n automernate
```

Services are exposed on:

-   **Frontend**: `http://<minikube-ip>:30080`
-   **API Gateway**: `http://<minikube-ip>:30000`
-   **Product Service**: `http://<minikube-ip>:30001`
-   **User Service**: `http://<minikube-ip>:30002`
-   **Order Service**: `http://<minikube-ip>:30003`
-   **Payment Service**: `http://<minikube-ip>:30004`

### Scaling Services

Scale services horizontally:

```bash
# Scale user service to 6 replicaskubectl scale deployment user-service --replicas=6 -n automernate# View scaled podskubectl get pods -n automernate -l app=user-service# Check rollout statuskubectl rollout status deployment/user-service -n automernate
```

### Monitoring & Logs

```bash
# View all podskubectl get pods -n automernate# View pod detailskubectl describe pod <pod-name> -n automernate# View logskubectl logs <pod-name> -n automernate# Follow logskubectl logs -f deployment/api-gateway -n automernate# View all deploymentskubectl get deployments -n automernate# View all serviceskubectl get svc -n automernate
```

### Cleanup

```bash
# Delete all resourceskubectl delete namespace automernate# Stop Minikubeminikube stop# Delete Minikube clusterminikube delete
```

---

## 📊 Project Structure

```plaintext
automernate/├── frontend/                      # React frontend application│   ├── public/                   # Static files│   ├── src/│   │   ├── components/           # Reusable React components│   │   ├── pages/                # Page components│   │   ├── slices/               # Redux slices│   │   ├── routes/               # Route configurations│   │   └── utils/                # Utility functions│   ├── Dockerfile               # Frontend container config│   └── nginx.conf               # Nginx configuration│├── services/                     # Backend microservices│   ├── api-gateway/             # API Gateway service│   │   ├── server.js│   │   ├── package.json│   │   └── Dockerfile│   ││   ├── product-service/         # Product microservice│   │   ├── controllers/│   │   ├── models/│   │   ├── routes/│   │   ├── middleware/│   │   ├── server.js│   │   ├── package.json│   │   └── Dockerfile│   ││   ├── user-service/            # User microservice│   │   ├── controllers/│   │   ├── models/│   │   ├── routes/│   │   ├── middleware/│   │   ├── utils/│   │   ├── server.js│   │   ├── package.json│   │   └── Dockerfile│   ││   ├── order-service/           # Order microservice│   ├── payment-service/         # Payment microservice│   └── notification-service/    # Notification microservice│├── k8s/                         # Kubernetes manifests│   ├── secret.yaml              # Secrets configuration│   ├── configmap-microservices.yaml│   ├── product-service.yaml│   ├── user-service.yaml│   ├── order-service.yaml│   ├── payment-service.yaml│   ├── notification-service.yaml│   ├── api-gateway.yaml│   └── frontend.yaml│├── uploads/                     # Product images├── data-migration/              # Database migration scripts│├── docker-compose-microservices.yml  # Docker Compose config├── build-docker-images.ps1      # Build script├── deploy-k8s-microservices.ps1 # Deployment script├── start-all-services.ps1       # Dev startup script├── package.json└── README.md
```

---

## 🔐 Environment Variables

### Required Variables

Variable

Description

Example

`NODE_ENV`

Environment mode

`development` or `production`

`PORT`

Service port

`5000`, `5001`, etc.

`MONGO_URI`

MongoDB connection string

`mongodb+srv://user:pass@cluster.mongodb.net/db`

`JWT_SECRET`

Secret for JWT tokens

`your_secret_key`

`RAZORPAY_KEY_ID`

Razorpay API key

`rzp_test_xxxxx`

`RAZORPAY_KEY_SECRET`

Razorpay API secret

`xxxxx`

`EMAIL_HOST`

SMTP server

`smtp.gmail.com`

`EMAIL_PORT`

SMTP port

`587`

`EMAIL_USER`

Email address

`your-email@gmail.com`

`EMAIL_PASS`

Email app password

`xxxx xxxx xxxx xxxx`

### Service-Specific Variables

**API Gateway:**

```env
PRODUCT_SERVICE_URL=http://product-service:5001USER_SERVICE_URL=http://user-service:5002ORDER_SERVICE_URL=http://order-service:5003PAYMENT_SERVICE_URL=http://payment-service:5004NOTIFICATION_SERVICE_URL=http://notification-service:5005
```

---

## 🧪 Testing

### API Testing

Test individual services:

```bash
# Test Product Servicecurl http://localhost:5001/api/products# Test User Service (Login)curl -X POST http://localhost:5002/api/users/login   -H "Content-Type: application/json"   -d '{"email":"admin@example.com","password":"123456"}'# Test Order Servicecurl http://localhost:5003/api/orders   -H "Authorization: Bearer <your-jwt-token>"
```

### Health Checks

```bash
# Check all service healthcurl http://localhost:5001/healthcurl http://localhost:5002/healthcurl http://localhost:5003/healthcurl http://localhost:5004/healthcurl http://localhost:5005/health
```

---

## 🐛 Troubleshooting

### Common Issues

**1. Port Already in Use**

```bash
# Find process using portnetstat -ano | findstr :5000# Kill process (Windows)taskkill /PID <process-id> /F
```

**2. MongoDB Connection Failed**

-   Verify MongoDB Atlas IP whitelist includes your IP
-   Check connection string format
-   Ensure network connectivity

**3. Docker Build Fails**

```bash
# Clean Docker cachedocker system prune -a# Rebuild without cachedocker build --no-cache -t image-name .
```

**4. Kubernetes Pods Not Starting**

```bash
# Check pod logskubectl logs <pod-name> -n automernate# Describe pod for eventskubectl describe pod <pod-name> -n automernate# Check image availabilityminikube image ls | grep automernate
```

**5. bcrypt Module Error**

```bash
# Rebuild bcrypt for current platformnpm rebuild bcrypt --build-from-source
```

---

## 📚 Documentation

-   [MLOPS Assignment Guide](./MLOPS_ASSIGNMENT_GUIDE.md) - Complete MLOps workflow
-   [Quick Start Guide](./QUICK_START.md) - Fast setup instructions
-   [Local Testing Guide](./LOCAL_TESTING_GUIDE.md) - Testing procedures
-   [Final Submission](./FINAL_SUBMISSION.md) - Complete DevOps documentation
-   [Kubernetes README](./k8s/README.md) - K8s deployment details

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1.  Fork the repository
2.  Create a feature branch (`git checkout -b feature/AmazingFeature`)
3.  Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4.  Push to the branch (`git push origin feature/AmazingFeature`)
5.  Open a Pull Request

---

## 📄 License

This project is for educational purposes as part of MLOps coursework.

---

## 👨‍💻 Author

**Muhammad Bilal Raza Attari**

-   GitHub: [@Bilal-Raza-SWE](https://github.com/Bilal-Raza-SWE)
-   Student ID: i222559
-   Section: SE-B
-   Course: MLOps (Semester 7)

---

## 🙏 Acknowledgments

-   FAST NUCES for MLOps curriculum
-   React and MERN stack communities
-   Docker and Kubernetes documentation
-   MongoDB Atlas for cloud database services

---

## 📞 Support

For issues, questions, or suggestions:

-   Open an issue in this repository
-   Contact: [GitHub Issues](https://github.com/Bilal-Raza-SWE/automernate/issues)

---

### ⭐ Star this repository if you found it helpful!

**Made with ❤️ for MLOps Assignment**

PAGINATION_LIMIT=8

# Gmail SMTP Configuration

EMAIL_HOST=smtp.gmail.comEMAIL_PORT=587EMAIL_USER=[your_email@gmail.com](mailto:your_email@gmail.com)EMAIL_PASS=your_16_char_app_passwordEMAIL_FROM=[noreply@automernate.com](mailto:noreply@automernate.com)

```
**Note:** To get Gmail App Password:1. Enable 2-Factor Authentication in your Google Account2. Go to [https://myaccount.google.com/apppasswords](https://myaccount.google.com/apppasswords)3. Create new app password for "Mail"4. Copy the 16-character password and use it in EMAIL_PASS4. **Seed the Database (Optional)**Populate the database with sample products and users:```bashnpm run data:import
```

To destroy all data:

```bash
npm run data:destroy
```

### Running the Application

**Microservices Mode** (recommended):

```bash
docker-compose -f docker-compose-microservices.yml up --build
```

**Monolithic Mode** (legacy):

```bash
docker-compose up --build
```

The application will be available at:

-   Frontend: `http://localhost:3000`
-   API Gateway: `http://localhost:5000`

### Data Migration

To migrate data from monolithic to microservices:

```bash
cd data-migrationnpm installnpm run migrate
```

This will install all dependencies and create an optimized production build of the frontend.

## Default Login Credentials

After seeding the database, you can use these credentials:

# Import data

npm run data:import

# Destroy data

npm run data:destroy

```
## Sample User Logins- **Live Admin Dashboard Login:**: [https://mern-shop-abxs.onrender.com/admin/login](https://mern-shop-abxs.onrender.com/admin/login)  - Email: admin@admin.com---## 📞 SupportFor issues, questions, or suggestions:- Open an issue in this repository- Contact: [GitHub Issues](https://github.com/Bilal-Raza-SWE/automernate/issues)---<div align="center">### ⭐ Star this repository if you found it helpful**Made with ❤️ for MLOps Assignment**</div>
```