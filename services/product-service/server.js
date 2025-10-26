// AutoMERNate Product Service
// Author: Muhammad Bilal Raza Attari
// Microservice for handling all product-related operations

import express from 'express';
import mongoose from 'mongoose';
import cors from 'cors';
import path from 'path';
import { fileURLToPath } from 'url';
import 'dotenv/config';
import productRoutes from './routes/productRoutes.js';
import uploadRoutes from './routes/uploadRoutes.js';
import { notFound, errorHandler } from './middleware/errorMiddleware.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();
const PORT = process.env.PRODUCT_SERVICE_PORT || 5001;

// Middleware
app.use(cors({
  origin: true,
  credentials: true
}));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Serve static files from uploads directory
app.use('/uploads', express.static(path.join(__dirname, '../../uploads')));

// MongoDB Connection
const connectDB = async () => {
  try {
    const mongoUri = process.env.MONGO_URI_PRODUCT || `${process.env.MONGO_URI}products`;
    const conn = await mongoose.connect(mongoUri);
    console.log(`✅ Product Service - MongoDB Connected: ${conn.connection.host}, DB: ${conn.connection.db.databaseName}`);
  } catch (error) {
    console.error(`❌ Product Service - MongoDB Error: ${error.message}`);
    console.log('⚠️  Service will continue without database connection. Please check MongoDB Atlas IP whitelist.');
    // Don't exit - allow service to run for testing
    // process.exit(1);
  }
};

connectDB();

// Health Check
app.get('/health', (req, res) => {
  res.json({ 
    service: 'Product Service', 
    status: 'healthy',
    port: PORT,
    timestamp: new Date().toISOString()
  });
});

// Routes
app.use('/api/v1/products', productRoutes);
app.use('/api/v1/upload', uploadRoutes);

// Error Handlers
app.use(notFound);
app.use(errorHandler);

app.listen(PORT, () => {
  console.log(`🛍️  Product Service running on port ${PORT}`);
});
