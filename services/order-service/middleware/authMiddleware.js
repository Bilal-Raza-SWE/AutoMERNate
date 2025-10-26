import jwt from 'jsonwebtoken';

// Simplified auth middleware for Order Service
export const protect = async (req, res, next) => {
  try {
    const token = req.cookies.jwt;

    if (!token) {
      res.statusCode = 401;
      throw new Error('Authentication failed: Token not provided.');
    }

    const decodedToken = jwt.verify(token, process.env.JWT_SECRET);

    if (!decodedToken) {
      res.statusCode = 401;
      throw new Error('Authentication failed: Invalid token.');
    }

    // Store user info from token
    req.user = { _id: decodedToken.userId };

    next();
  } catch (error) {
    next(error);
  }
};

// Admin middleware
export const admin = (req, res, next) => {
  // In microservices, we'd need to call User Service to check admin status
  // For now, simplified version
  next();
};
