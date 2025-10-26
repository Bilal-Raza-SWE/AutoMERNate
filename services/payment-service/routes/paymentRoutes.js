import express from 'express';
import { getConfig, createOrder, validatePayment } from '../controllers/paymentController.js';

const router = express.Router();

router.get('/key', getConfig);
router.post('/razorpay', createOrder);
router.post('/validate', validatePayment);

export default router;
