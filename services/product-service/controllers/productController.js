import Product from '../models/productModel.js';
import mongoose from 'mongoose';

// @desc     Fetch All Products
// @method   GET
// @endpoint /api/v1/products
// @access   Public
export const getProducts = async (req, res, next) => {
  try {
    // Check if MongoDB is connected
    if (mongoose.connection.readyState !== 1) {
      return res.status(503).json({
        message: 'Database not connected. Please whitelist your IP in MongoDB Atlas.',
        products: [],
        total: 0
      });
    }

    const total = await Product.countDocuments();
    const limit = Number(req.query.limit) || 8;
    const skip = Number(req.query.skip) || 0;
    const search = req.query.search || '';

    const products = await Product.find({
      name: { $regex: search, $options: 'i' }
    })
      .limit(limit)
      .skip(skip);

    res.status(200).json({
      products,
      total
    });
  } catch (error) {
    next(error);
  }
};

// @desc     Fetch top products
// @method   GET
// @endpoint /api/v1/products/top
// @access   Public
export const getTopProducts = async (req, res, next) => {
  try {
    const products = await Product.find({}).sort({ rating: -1 }).limit(3);
    res.status(200).json(products);
  } catch (error) {
    next(error);
  }
};

// @desc     Fetch Single Product
// @method   GET
// @endpoint /api/v1/products/:id
// @access   Public
export const getProduct = async (req, res, next) => {
  try {
    const { id: productId } = req.params;
    const product = await Product.findById(productId);

    if (!product) {
      res.statusCode = 404;
      throw new Error('Product not found!');
    }

    res.status(200).json(product);
  } catch (error) {
    next(error);
  }
};

// @desc     Create product
// @method   POST
// @endpoint /api/v1/products
// @access   Private/Admin
export const createProduct = async (req, res, next) => {
  try {
    const { name, image, description, brand, category, price, countInStock, user } = req.body;
    
    const product = new Product({
      user: user || '000000000000000000000000',
      name,
      image,
      description,
      brand,
      category,
      price,
      countInStock
    });
    
    const createdProduct = await product.save();
    res.status(201).json({ message: 'Product created', createdProduct });
  } catch (error) {
    next(error);
  }
};

// @desc     Update product
// @method   PUT
// @endpoint /api/v1/products/:id
// @access   Private/Admin
export const updateProduct = async (req, res, next) => {
  try {
    const { name, image, description, brand, category, price, countInStock } = req.body;
    const product = await Product.findById(req.params.id);

    if (!product) {
      res.statusCode = 404;
      throw new Error('Product not found!');
    }

    product.name = name || product.name;
    product.image = image || product.image;
    product.description = description || product.description;
    product.brand = brand || product.brand;
    product.category = category || product.category;
    product.price = price || product.price;
    product.countInStock = countInStock || product.countInStock;

    const updatedProduct = await product.save();
    res.status(200).json({ message: 'Product updated', updatedProduct });
  } catch (error) {
    next(error);
  }
};

// @desc    Delete product
// @method   DELETE
// @endpoint /api/v1/products/:id
// @access   Admin
export const deleteProduct = async (req, res, next) => {
  try {
    const { id: productId } = req.params;
    const product = await Product.findById(productId);

    if (!product) {
      res.statusCode = 404;
      throw new Error('Product not found!');
    }
    
    await Product.deleteOne({ _id: product._id });
    res.status(200).json({ message: 'Product deleted' });
  } catch (error) {
    next(error);
  }
};

// @desc    Create product review
// @method   POST
// @endpoint /api/v1/products/reviews/:id
// @access   Private
export const createProductReview = async (req, res, next) => {
  try {
    const { id: productId } = req.params;
    const { rating, comment, user, name } = req.body;

    const product = await Product.findById(productId);

    if (!product) {
      res.statusCode = 404;
      throw new Error('Product not found!');
    }

    const review = {
      user: user,
      name: name,
      rating: Number(rating),
      comment
    };

    product.reviews = [...product.reviews, review];
    product.numReviews = product.reviews.length;
    product.rating = product.reviews.reduce((acc, item) => item.rating + acc, 0) / product.reviews.length;

    await product.save();
    res.status(201).json({ message: 'Review added' });
  } catch (error) {
    next(error);
  }
};
