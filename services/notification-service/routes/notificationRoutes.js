import express from 'express';
import { sendEmail } from '../controllers/notificationController.js';

const router = express.Router();

// @desc     Send email notification
// @method   POST
// @endpoint /api/v1/notifications/email
// @access   Internal
router.post('/email', sendEmail);

export default router;