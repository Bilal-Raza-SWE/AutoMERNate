import express from 'express';
import cors from 'cors';
import 'dotenv/config';
import paymentRoutes from './routes/paymentRoutes.js';

const app = express();
const PORT = process.env.PAYMENT_SERVICE_PORT || 5004;

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Health Check
app.get('/health', (req, res) => {
  res.json({ 
    service: 'Payment Service', 
    status: 'healthy',
    port: PORT,
    timestamp: new Date().toISOString()
  });
});

// Routes
app.use('/api/v1/payment', paymentRoutes);

// Error handling
app.use((err, req, res, next) => {
  const statusCode = res.statusCode === 200 ? 500 : res.statusCode;
  res.status(statusCode).json({
    message: err.message,
    stack: process.env.NODE_ENV === 'production' ? '🥞' : err.stack
  });
});

app.listen(PORT, () => {
  console.log(`💳 Payment Service running on port ${PORT}`);
});
