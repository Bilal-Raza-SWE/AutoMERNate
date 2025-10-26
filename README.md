# AutoMERNate - Microservices E-Commerce Platform

**Author:** Muhammad Bilal Raza Attari

Welcome to **AutoMERNate**, a fully decentralized, domain-driven microservices e-commerce platform. This project has been converted from a monolithic architecture to a pure microservices system with isolated services communicating through APIs.

## Architecture

AutoMERNate now follows a microservices architecture with the following services:

- **API Gateway**: Routes requests to appropriate services
- **User Service**: Handles user authentication, profiles, and management
- **Product Service**: Manages product catalog, inventory, and reviews
- **Order Service**: Processes orders and shopping cart functionality
- **Payment Service**: Handles payment processing via Razorpay
- **Notification Service**: Sends emails and notifications
- **Frontend**: React-based user interface

Each service has its own database, deployment, and scalability.

## Features

- **Full-Featured Shopping Cart**: Seamless shopping cart functionality for users to add, remove, and manage products.
- **Product Reviews and Ratings**: Users can leave reviews and provide ratings for products.
- **Top Products Carousel**: Display a carousel of top-rated or featured products.
- **Product Pagination**: Navigate through products efficiently with pagination.
- **Product Search Feature**: Easily search for products based on keywords.
- **User Profile with Orders**: Users can create profiles and track their order history.
- **Admin Dashboard**: Comprehensive dashboard for administrators to manage admins, products, users, and orders.
- **Admin Admin Management**: Manage admin accounts.
- **Admin Product Management**: Add, edit, and delete products from the platform.
- **Admin User Management**: Manage user accounts.
- **Admin Order Details Page**: Access detailed information about each order.
- **Mark Orders as Delivered Option**: Ability to update order status to "delivered."
- **Checkout Process**: Seamless checkout with options for shipping and payment methods.
- **Razorpay Integration**: Secure payment processing through Razorpay.
- **Database Seeder**: Easily populate the database with sample products and users.

## Getting Started

### Prerequisites

Before you begin, ensure you have the following installed:
- **Node.js** (v14 or higher) - [Download here](https://nodejs.org/)
- **MongoDB** - Either local installation or MongoDB Atlas account
- **Git** - For cloning the repository
- **Razorpay Account** - For payment integration ([Sign up](https://razorpay.com/))
- **Gmail Account** - For email services with App Password enabled

### Installation Steps

1. **Clone the Repository**

```bash
git clone https://github.com/Bilal-Raza-SWE/automernate.git
cd automernate
```

2. **Install Dependencies**

Install dependencies for each service:

```bash
# API Gateway
cd services/api-gateway
npm install
cd ../..

# User Service
cd services/user-service
npm install
cd ../..

# Product Service
cd services/product-service
npm install
cd ../..

# Order Service
cd services/order-service
npm install
cd ../..

# Payment Service
cd services/payment-service
npm install
cd ../..

# Notification Service
cd services/notification-service
npm install
cd ../..

# Frontend
cd frontend
npm install
cd ..
```

3. **Configure Environment Variables**

Create `.env` files in each service directory based on the provided examples.

For microservices mode, use `docker-compose-microservices.yml`.

```dotenv
NODE_ENV=development
PORT=5000
JWT_SECRET=your_strong_jwt_secret_here
MONGO_URI=mongodb://localhost:27017/automernate
# Or for MongoDB Atlas: mongodb+srv://username:password@cluster.mongodb.net/automernate

RAZORPAY_KEY_ID=your_razorpay_key_id
RAZORPAY_KEY_SECRET=your_razorpay_key_secret
PAGINATION_LIMIT=8

# Gmail SMTP Configuration
EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_USER=your_email@gmail.com
EMAIL_PASS=your_16_char_app_password
EMAIL_FROM=<noreply@automernate.com>
```

**Note:** To get Gmail App Password:
1. Enable 2-Factor Authentication in your Google Account
2. Go to [https://myaccount.google.com/apppasswords](https://myaccount.google.com/apppasswords)
3. Create new app password for "Mail"
4. Copy the 16-character password and use it in EMAIL_PASS

4. **Seed the Database (Optional)**

Populate the database with sample products and users:
```bash
npm run data:import
```

To destroy all data:
```bash
npm run data:destroy
```

### Running the Application

**Microservices Mode** (recommended):
```bash
docker-compose -f docker-compose-microservices.yml up --build
```

**Monolithic Mode** (legacy):
```bash
docker-compose up --build
```

The application will be available at:
- Frontend: `http://localhost:3000`
- API Gateway: `http://localhost:5000`

### Data Migration

To migrate data from monolithic to microservices:
```bash
cd data-migration
npm install
npm run migrate
```

This will install all dependencies and create an optimized production build of the frontend.

## Default Login Credentials

After seeding the database, you can use these credentials:
# Import data
npm run data:import

# Destroy data
npm run data:destroy
```

## Sample User Logins

- **Live Admin Dashboard Login:**: [https://mern-shop-abxs.onrender.com/admin/login](https://mern-shop-abxs.onrender.com/admin/login)

  - Email: admin@admin.com
  - Password: admin123

- **Live Customer Logins:**: [https://mern-shop-abxs.onrender.com/login](https://mern-shop-abxs.onrender.com/login)
  - John Doe
    - Email: john@email.com
    - Password: john123
  - Alice Smith
    - Email: alice@email.com
    - Password: alice123

Feel free to explore and customize this eCommerce platform for your specific needs. Happy coding🤩!

# Contributing to the eCommerce Platform Project

We welcome and appreciate contributions from the community to enhance and improve the eCommerce Platform Project. Whether you're a developer, designer, tester, or someone with valuable feedback, your input is valuable. Here's how you can contribute:

## Getting Started

1. Fork the repository to your GitHub account.

2. Clone the forked repository to your local machine:

   ```bash
   git clone https://github.com/your-username/MERN-eCommerce.git
   ```

3. Navigate to the project directory:

   ```bash
   cd MERN-eCommerce
   ```

4. Create a new branch for your contributions:

   ```bash
   git checkout -b feature/your-feature-name
   git checkout -b issues/your-issue-name
   ```

## Making Changes

1. Implement your changes and improvements.

2. Ensure that your changes adhere to the project's coding style and conventions.

3. Test your changes thoroughly to avoid introducing bugs.

4. Update the project documentation if necessary.

## Committing Changes

1. Commit your changes with a descriptive commit message:

   ```bash
   git add .
   git commit -m "Add your descriptive commit message here"
   ```

2. Push your changes to your forked repository:

   ```bash
   git push origin feature/your-feature-name
   git push origin issues/your-issue-name
   ```

## Creating a Pull Request (PR)

1. Visit your forked repository on GitHub.

2. Switch to the branch containing your changes.

3. Click on the "New Pull Request" button.

4. Provide a clear title and description for your pull request, explaining the purpose and scope of your changes.

5. Submit the pull request.

## Code Review

Your contribution will be reviewed by the project maintainers. Be prepared to address any feedback or suggestions to ensure the quality and compatibility of your changes.

## Thank You!

Thank you for considering contributing to the eCommerce Platform Project. Your efforts help make this project better for everyone. If you have any questions or need assistance, feel free to reach out through the issue tracker or discussions. Happy coding🤩!
