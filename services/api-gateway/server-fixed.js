import express from 'express';
import { createProxyMiddleware } from 'http-proxy-middleware';
import cors from 'cors';
import 'dotenv/config';

const app = express();
const PORT = process.env.API_GATEWAY_PORT || 5000;

// Enable CORS for frontend
app.use(cors({
  origin: ['http://localhost:3000', 'http://localhost:3001'],
  credentials: true
}));

// Add body parsing ONLY for non-proxy routes
app.use('/test', express.json());

// Test route to verify POST works
app.post('/test/echo', (req, res) => {
  res.json({ 
    message: 'Echo test successful',
    receivedBody: req.body,
    timestamp: new Date().toISOString()
  });
});

// Health Check
app.get('/health', (req, res) => {
  res.json({ 
    service: 'API Gateway', 
    status: 'healthy',
    port: PORT,
    timestamp: new Date().toISOString()
  });
});

// Proxy configuration options
const proxyOptions = {
  changeOrigin: true,
  logLevel: 'warn',
  ws: true,
  onProxyReq: (proxyReq, req, res) => {
    console.log(`→ ${req.method} ${req.url}`);
  },
  onProxyRes: (proxyRes, req, res) => {
    console.log(`← ${proxyRes.statusCode} ${req.url}`);
  },
  onError: (err, req, res) => {
    console.error(`✗ Proxy Error: ${err.message}`);
    if (!res.headersSent) {
      res.status(502).json({ 
        error: 'Bad Gateway',
        message: 'Failed to connect to backend service',
        details: err.message
      });
    }
  }
};

// Product Service Proxy
app.use('/api/v1/products', createProxyMiddleware({
  ...proxyOptions,
  target: 'http://localhost:5001'
}));

// User Service Proxy  
app.use('/api/v1/users', createProxyMiddleware({
  ...proxyOptions,
  target: 'http://localhost:5002'
}));

// Order Service Proxy
app.use('/api/v1/orders', createProxyMiddleware({
  ...proxyOptions,
  target: 'http://localhost:5003'
}));

// Payment Service Proxy
app.use('/api/v1/payment', createProxyMiddleware({
  ...proxyOptions,
  target: 'http://localhost:5004'
}));

// Notification Service Proxy
app.use('/api/v1/notifications', createProxyMiddleware({
  ...proxyOptions,
  target: 'http://localhost:5005'
}));

// Upload endpoints proxy to Product Service
app.use('/api/v1/upload', createProxyMiddleware({
  ...proxyOptions,
  target: 'http://localhost:5001'
}));

// Static uploads folder proxy to Product Service
app.use('/uploads', createProxyMiddleware({
  ...proxyOptions,
  target: 'http://localhost:5001'
}));

// 404 Handler
app.use('*', (req, res) => {
  res.status(404).json({ 
    error: 'Not Found',
    message: `Route ${req.originalUrl} not found`,
    availableRoutes: [
      '/api/v1/products',
      '/api/v1/users',
      '/api/v1/orders',
      '/api/v1/payment',
      '/api/v1/notifications'
    ]
  });
});

app.listen(PORT, () => {
  console.log(`\n🚪 API Gateway running on port ${PORT}`);
  console.log(`📡 Proxying to:\n`);
  console.log(`   Products:      http://localhost:5001`);
  console.log(`   Users:         http://localhost:5002`);
  console.log(`   Orders:        http://localhost:5003`);
  console.log(`   Payment:       http://localhost:5004`);
  console.log(`   Notifications: http://localhost:5005`);
  console.log(`\n✅ Ready to route requests\n`);
});
