import { validationResult } from 'express-validator';

const validateRequest = (req, res, next) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    res.statusCode = 400;
    throw new Error(errors.array()[0].msg);
  }
  next();
};

export default validateRequest;
