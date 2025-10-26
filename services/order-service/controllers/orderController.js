import Order from '../models/orderModel.js';
import axios from 'axios';

// @desc     Create new order
// @method   POST
// @endpoint /api/v1/orders
// @access   Private
export const addOrderItems = async (req, res, next) => {
  try {
    const {
      cartItems,
      shippingAddress,
      paymentMethod,
      itemsPrice,
      taxPrice,
      shippingPrice,
      totalPrice
    } = req.body;

    if (!cartItems || cartItems.length === 0) {
      res.statusCode = 400;
      throw new Error('No order items.');
    }

    const order = new Order({
      user: req.user._id,
      orderItems: cartItems.map(item => ({
        ...item,
        product: item._id
      })),
      shippingAddress,
      paymentMethod,
      itemsPrice,
      taxPrice,
      shippingPrice,
      totalPrice
    });

    const createdOrder = await order.save();

    res.status(201).json(createdOrder);
  } catch (error) {
    next(error);
  }
};

// @desc     Get logged-in user orders
// @method   GET
// @endpoint /api/v1/orders/my-orders
// @access   Private
export const getMyOrders = async (req, res, next) => {
  try {
    const orders = await Order.find({ user: req.user._id });

    if (!orders || orders.length === 0) {
      res.statusCode = 404;
      throw new Error('No orders found for the logged-in user.');
    }

    res.status(200).json(orders);
  } catch (error) {
    next(error);
  }
};

// @desc     Get order by ID
// @method   GET
// @endpoint /api/v1/orders/:id
// @access   Private
export const getOrderById = async (req, res, next) => {
  try {
    const { id: orderId } = req.params;

    const order = await Order.findById(orderId);

    if (!order) {
      res.statusCode = 404;
      throw new Error('Order not found!');
    }

    // Fetch user data from user-service
    const userServiceUrl = process.env.USER_SERVICE_URL || 'http://localhost:5002';
    const userResponse = await axios.get(`${userServiceUrl}/api/v1/users/${order.user}`);
    const user = userResponse.data;

    // Attach user data to order
    const orderWithUser = {
      ...order.toObject(),
      user: {
        _id: user._id,
        name: user.name,
        email: user.email
      }
    };

    res.status(200).json(orderWithUser);
  } catch (error) {
    next(error);
  }
};

// @desc     Update order to paid
// @method   PUT
// @endpoint /api/v1/orders/:id/pay
// @access   Private
export const updateOrderToPaid = async (req, res, next) => {
  try {
    const { id: orderId } = req.params;
    const order = await Order.findById(orderId);

    if (!order) {
      res.statusCode = 404;
      throw new Error('Order not found!');
    }

    order.isPaid = true;
    order.paidAt = new Date();
    order.paymentResult = {
      id: req.body.id,
      status: req.body.status,
      update_time: req.body.updateTime,
      email_address: req.body.email
    };

    const updatedOrder = await order.save();

    res.status(200).json(updatedOrder);
  } catch (error) {
    next(error);
  }
};

// @desc     Update order to delivered
// @method   PUT
// @endpoint /api/v1/orders/:id/deliver
// @access   Private/Admin
export const updateOrderToDeliver = async (req, res, next) => {
  try {
    const { id: orderId } = req.params;
    const order = await Order.findById(orderId);

    if (!order) {
      res.statusCode = 404;
      throw new Error('Order not found!');
    }

    order.isDelivered = true;
    order.deliveredAt = new Date();

    const updatedDeliver = await order.save();

    res.status(200).json(updatedDeliver);
  } catch (error) {
    next(error);
  }
};

// @desc     Get all orders
// @method   GET
// @endpoint /api/v1/orders
// @access   Private/Admin
export const getOrders = async (req, res, next) => {
  try {
    const orders = await Order.find();

    if (!orders || orders.length === 0) {
      res.statusCode = 404;
      throw new Error('Orders not found!');
    }

    // Fetch user data for each order
    const userServiceUrl = process.env.USER_SERVICE_URL || 'http://localhost:5002';
    const ordersWithUsers = await Promise.all(
      orders.map(async (order) => {
        try {
          const userResponse = await axios.get(`${userServiceUrl}/api/v1/users/${order.user}`);
          const user = userResponse.data;
          return {
            ...order.toObject(),
            user: {
              _id: user._id,
              name: user.name
            }
          };
        } catch (error) {
          // If user not found, return order without user data
          return order.toObject();
        }
      })
    );

    res.status(200).json(ordersWithUsers);
  } catch (error) {
    next(error);
  }
};
