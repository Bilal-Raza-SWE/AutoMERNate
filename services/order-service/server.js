import express from 'express';
import mongoose from 'mongoose';
import cors from 'cors';
import cookieParser from 'cookie-parser';
import 'dotenv/config';
import orderRoutes from './routes/orderRoutes.js';
import { notFound, errorHandler } from './middleware/errorMiddleware.js';

const app = express();
const PORT = process.env.ORDER_SERVICE_PORT || 5003;

// Middleware
app.use(cors({
  origin: true,
  credentials: true
}));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cookieParser());

// MongoDB Connection
const connectDB = async () => {
  try {
    const mongoUri = process.env.MONGO_URI_ORDER || `${process.env.MONGO_URI}orders`;
    const conn = await mongoose.connect(mongoUri);
    console.log(`✅ Order Service - MongoDB Connected: ${conn.connection.host}, DB: ${conn.connection.db.databaseName}`);
  } catch (error) {
    console.error(`❌ Order Service - MongoDB Error: ${error.message}`);
    console.log('⚠️  Service will continue without database connection. Please check MongoDB Atlas IP whitelist.');
    // Don't exit - allow service to run for testing
    // process.exit(1);
  }
};

connectDB();

// Health Check
app.get('/health', (req, res) => {
  res.json({ 
    service: 'Order Service', 
    status: 'healthy',
    port: PORT,
    timestamp: new Date().toISOString()
  });
});

// Routes
app.use('/api/v1/orders', orderRoutes);

// Error handling middleware
app.use(notFound);
app.use(errorHandler);

app.listen(PORT, () => {
  console.log(`📦 Order Service running on port ${PORT}`);
});
