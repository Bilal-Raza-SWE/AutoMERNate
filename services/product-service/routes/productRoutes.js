import express from 'express';
import {
  getProducts,
  getProduct,
  deleteProduct,
  createProduct,
  updateProduct,
  createProductReview,
  getTopProducts
} from '../controllers/productController.js';

const router = express.Router();

router.route('/')
  .post(createProduct)
  .get(getProducts);
  
router.get('/top', getTopProducts);
router.post('/reviews/:id', createProductReview);

router.route('/:id')
  .get(getProduct)
  .put(updateProduct)
  .delete(deleteProduct);

export default router;
