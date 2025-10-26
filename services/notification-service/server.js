import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';
import notificationRoutes from './routes/notificationRoutes.js';

// Get directory paths
const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

// Load environment variables from root .env file
dotenv.config({ path: join(__dirname, '../../.env') });

const app = express();
const PORT = process.env.NOTIFICATION_SERVICE_PORT || 5005;

// Middleware
app.use(cors());
app.use(express.json());

// Routes
app.use('/api/v1/notifications', notificationRoutes);

// Health check
app.get('/health', (req, res) => {
  res.json({
    service: 'Notification Service',
    status: 'healthy',
    port: PORT
  });
});

app.listen(PORT, () => {
  console.log(`Notification Service running on port ${PORT}`);
  console.log(`Email Configuration:`);
  console.log(`  Host: ${process.env.EMAIL_HOST || 'NOT SET'}`);
  console.log(`  Port: ${process.env.EMAIL_PORT || 'NOT SET'}`);
  console.log(`  User: ${process.env.EMAIL_USER || 'NOT SET'}`);
  console.log(`  Password: ${process.env.EMAIL_PASS ? '***SET***' : 'NOT SET'}`);
});