import mongoose from 'mongoose';
import 'dotenv/config';

// Connect to original DB
const originalDb = await mongoose.createConnection(process.env.MONGO_URI);

// Connect to new DBs
const userDb = await mongoose.createConnection(`${process.env.MONGO_URI}users`);
const productDb = await mongoose.createConnection(`${process.env.MONGO_URI}products`);
const orderDb = await mongoose.createConnection(`${process.env.MONGO_URI}orders`);

// Define schemas for original DB
const originalUserSchema = new mongoose.Schema({
  name: String,
  email: String,
  password: String,
  isAdmin: Boolean
}, { timestamps: true });

const originalProductSchema = new mongoose.Schema({
  user: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  name: String,
  image: String,
  description: String,
  brand: String,
  category: String,
  price: Number,
  countInStock: Number,
  rating: Number,
  numReviews: Number,
  reviews: [{
    user: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
    name: String,
    rating: Number,
    comment: String
  }]
}, { timestamps: true });

const originalOrderSchema = new mongoose.Schema({
  user: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  orderItems: [{
    name: String,
    qty: Number,
    image: String,
    price: Number,
    product: { type: mongoose.Schema.Types.ObjectId, ref: 'Product' }
  }],
  shippingAddress: {
    address: String,
    city: String,
    postalCode: String,
    country: String
  },
  paymentMethod: String,
  paymentResult: Object,
  itemsPrice: Number,
  taxPrice: Number,
  shippingPrice: Number,
  totalPrice: Number,
  isPaid: Boolean,
  paidAt: Date,
  isDelivered: Boolean,
  deliveredAt: Date
}, { timestamps: true });

const OriginalUser = originalDb.model('User', originalUserSchema);
const OriginalProduct = originalDb.model('Product', originalProductSchema);
const OriginalOrder = originalDb.model('Order', originalOrderSchema);

// Define schemas for new DBs
const newUserSchema = new mongoose.Schema({
  name: String,
  email: String,
  password: String,
  isAdmin: Boolean
}, { timestamps: true });

const newProductSchema = new mongoose.Schema({
  user: String,
  name: String,
  image: String,
  description: String,
  brand: String,
  category: String,
  price: Number,
  countInStock: Number,
  rating: Number,
  numReviews: Number,
  reviews: [{
    user: String,
    name: String,
    rating: Number,
    comment: String
  }]
}, { timestamps: true });

const newOrderSchema = new mongoose.Schema({
  user: String,
  orderItems: [{
    name: String,
    qty: Number,
    image: String,
    price: Number,
    product: String
  }],
  shippingAddress: {
    address: String,
    city: String,
    postalCode: String,
    country: String
  },
  paymentMethod: String,
  paymentResult: Object,
  itemsPrice: Number,
  taxPrice: Number,
  shippingPrice: Number,
  totalPrice: Number,
  isPaid: Boolean,
  paidAt: Date,
  isDelivered: Boolean,
  deliveredAt: Date
}, { timestamps: true });

const NewUser = userDb.model('User', newUserSchema);
const NewProduct = productDb.model('Product', newProductSchema);
const NewOrder = orderDb.model('Order', newOrderSchema);

async function migrate() {
  try {
    console.log('Starting migration...');

    // Migrate users
    const users = await OriginalUser.find();
    for (const user of users) {
      await NewUser.create({
        name: user.name,
        email: user.email,
        password: user.password,
        isAdmin: user.isAdmin
      });
    }
    console.log(`Migrated ${users.length} users`);

    // Migrate products
    const products = await OriginalProduct.find();
    for (const product of products) {
      const reviews = product.reviews.map(review => ({
        user: review.user.toString(),
        name: review.name,
        rating: review.rating,
        comment: review.comment
      }));
      await NewProduct.create({
        user: product.user.toString(),
        name: product.name,
        image: product.image,
        description: product.description,
        brand: product.brand,
        category: product.category,
        price: product.price,
        countInStock: product.countInStock,
        rating: product.rating,
        numReviews: product.numReviews,
        reviews
      });
    }
    console.log(`Migrated ${products.length} products`);

    // Migrate orders
    const orders = await OriginalOrder.find();
    for (const order of orders) {
      const orderItems = order.orderItems.map(item => ({
        name: item.name,
        qty: item.qty,
        image: item.image,
        price: item.price,
        product: item.product.toString()
      }));
      await NewOrder.create({
        user: order.user.toString(),
        orderItems,
        shippingAddress: order.shippingAddress,
        paymentMethod: order.paymentMethod,
        paymentResult: order.paymentResult,
        itemsPrice: order.itemsPrice,
        taxPrice: order.taxPrice,
        shippingPrice: order.shippingPrice,
        totalPrice: order.totalPrice,
        isPaid: order.isPaid,
        paidAt: order.paidAt,
        isDelivered: order.isDelivered,
        deliveredAt: order.deliveredAt
      });
    }
    console.log(`Migrated ${orders.length} orders`);

    console.log('Migration completed successfully');
  } catch (error) {
    console.error('Migration failed:', error);
  } finally {
    await originalDb.close();
    await userDb.close();
    await productDb.close();
    await orderDb.close();
  }
}

migrate();