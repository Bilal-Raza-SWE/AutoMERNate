# 🚀 AutoMERNate Local Testing Guide
**Author:** Muhammad Bilal Raza Attari  
**Date:** October 26, 2025

---

## 🔥 CRITICAL: Fix MongoDB Atlas IP Whitelist FIRST

### **Problem:**
Your services cannot connect to MongoDB Atlas because your current IP address is not whitelisted.

### **Solution (Takes 30 seconds):**

1. **You're already on the right page!** (MongoDB Atlas connection page)
2. Click the green button: **"Add Current IP Address"**
3. Wait 10-20 seconds for the change to propagate
4. Your services will automatically connect to MongoDB

**Alternative:** If button doesn't work:
1. Go to MongoDB Atlas → Network Access (left sidebar)
2. Click "Add IP Address"
3. Click "Add Current IP Address"
4. Confirm

---

## ✅ Current System Status

### **All Services Running:**
- ✅ Product Service - Port 5001
- ✅ User Service - Port 5002
- ✅ Order Service - Port 5003
- ✅ Payment Service - Port 5004
- ✅ Notification Service - Port 5005
- ✅ API Gateway - Port 5000
- ✅ Frontend - Port 3000

### **Configuration Fixed:**
- ✅ Frontend `BASE_URL` now points to API Gateway (`http://localhost:5000`)
- ✅ Services continue running even if MongoDB fails
- ✅ Error handlers properly configured

---

## 🧪 Test Your System (Step-by-Step)

### **After Adding Your IP to MongoDB Atlas:**

1. **Restart all backend services** (they will now connect to MongoDB):
   ```powershell
   # In separate terminals, run these commands:
   
   # Terminal 1 - Product Service
   cd "d:\FAST NU\Semester - 07\MLOPs\i222559_SE-B_Assignment-02\AutoMernate\services\product-service"
   npm start
   
   # Terminal 2 - User Service
   cd "d:\FAST NU\Semester - 07\MLOPs\i222559_SE-B_Assignment-02\AutoMernate\services\user-service"
   npm start
   
   # Terminal 3 - Order Service
   cd "d:\FAST NU\Semester - 07\MLOPs\i222559_SE-B_Assignment-02\AutoMernate\services\order-service"
   npm start
   
   # Terminal 4 - Payment Service
   cd "d:\FAST NU\Semester - 07\MLOPs\i222559_SE-B_Assignment-02\AutoMernate\services\payment-service"
   npm start
   
   # Terminal 5 - Notification Service
   cd "d:\FAST NU\Semester - 07\MLOPs\i222559_SE-B_Assignment-02\AutoMernate\services\notification-service"
   npm start
   
   # Terminal 6 - API Gateway
   cd "d:\FAST NU\Semester - 07\MLOPs\i222559_SE-B_Assignment-02\AutoMernate\services\api-gateway"
   npm start
   
   # Terminal 7 - Frontend
   cd "d:\FAST NU\Semester - 07\MLOPs\i222559_SE-B_Assignment-02\AutoMernate\frontend"
   npm start
   ```

2. **Look for success messages:**
   ```
   ✅ Product Service - MongoDB Connected: automernate-cluster.nsicand.mongodb.net
   ✅ User Service - MongoDB Connected: automernate-cluster.nsicand.mongodb.net
   ✅ Order Service - MongoDB Connected: automernate-cluster.nsicand.mongodb.net
   ```

3. **Test the API Gateway:**
   ```powershell
   Invoke-RestMethod -Uri http://localhost:5000/health
   ```

4. **Test Product Service:**
   ```powershell
   Invoke-RestMethod -Uri http://localhost:5000/api/v1/products
   ```

5. **Open Frontend:**
   - Navigate to: `http://localhost:3000`
   - You should see the AutoMERNate homepage
   - Products should load (if database has data)

---

## 📊 What You Should See

### **In Browser (localhost:3000):**
- ✅ Homepage loads without errors
- ✅ No JSON parsing errors
- ✅ No "Cannot reach" errors
- ⚠️ Products may be empty if database has no data

### **In Terminals:**
```
🛍️  Product Service running on port 5001
✅ Product Service - MongoDB Connected: automernate-cluster.nsicand.mongodb.net

👤 User Service running on port 5002
✅ User Service - MongoDB Connected: automernate-cluster.nsicand.mongodb.net

📦 Order Service running on port 5003
✅ Order Service - MongoDB Connected: automernate-cluster.nsicand.mongodb.net

💳 Payment Service running on port 5004

📧 Notification Service running on port 5005

🚪 API Gateway running on port 5000
📡 Routing requests to microservices
```

---

## 🎯 Final Checklist

- [ ] MongoDB Atlas IP whitelisted (**MOST IMPORTANT**)
- [ ] All 6 backend services running
- [ ] API Gateway running on port 5000
- [ ] Frontend running on port 3000
- [ ] All services show "MongoDB Connected" (after IP whitelist)
- [ ] No errors in browser console
- [ ] Can access http://localhost:3000

---

## 🐛 Troubleshooting

### **Problem: Still seeing "Cannot connect" errors**
**Solution:** 
1. Clear browser cache (Ctrl + Shift + Delete)
2. Hard refresh (Ctrl + F5)
3. Check all services are running with `npm start`

### **Problem: MongoDB still not connecting**
**Solution:**
1. Wait 30 seconds after adding IP
2. Restart the specific service
3. Check Network Access in MongoDB Atlas shows your IP

### **Problem: "404 Not Found" on API calls**
**Solution:**
1. Verify API Gateway is running on port 5000
2. Check frontend `constants.js` has `BASE_URL = 'http://localhost:5000'`
3. Restart frontend with `npm start`

---

## 🎉 Success Criteria

Your system is working correctly when:
1. ✅ All terminals show services running
2. ✅ MongoDB connection messages appear (green checkmarks)
3. ✅ Frontend loads at http://localhost:3000
4. ✅ No errors in browser DevTools console
5. ✅ API calls return data (test with /health endpoint)

---

## 📝 Notes

- Services run on separate ports and communicate via HTTP
- Frontend calls API Gateway (port 5000), which routes to microservices
- Each microservice has its own MongoDB database
- This is a **pure microservices architecture**
- All services are independent and can be deployed separately

---

**Next Steps After Testing:**
1. Seed database with sample data
2. Test user registration and login
3. Test product CRUD operations
4. Test order placement flow
5. Deploy to Kubernetes (see k8s/ folder)
