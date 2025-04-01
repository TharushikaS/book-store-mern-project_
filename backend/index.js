const express = require('express');
const app = express();
const cors = require("cors");

const mongoose = require('mongoose');

const port = process.env.PORT || 5000;
require('dotenv').config();

// Middleware
app.use(express.json());
app.use(cors({
  origin: ['http://localhost:5173', 'https://book-app-frontend-tau.vercel.app'],  // Allowed frontend URLs
  credentials: true,
}));

// Routes
const bookRoutes = require('./src/books/book.route');
const orderRoutes = require('./src/orders/order.route');
const userRoutes = require('./src/users/user.route');  // Correct import
const adminRoutes = require('./src/stats/admin.stats');

// Use the routes
app.use("/api/books", bookRoutes);
app.use("/api/orders", orderRoutes);
app.use("/api/auth", userRoutes);  // Register user authentication routes
app.use("/api/admin", adminRoutes);

// MongoDB connection and server start
async function main() {
  try {
    await mongoose.connect(process.env.DB_URL);
    console.log("MongoDB connected successfully!");

    // Root route for testing
    app.use('/', (req, res) => {
      res.send('Book Store Server is running!');
    });

    // Start the server
    app.listen(port, () => {
      console.log(`Server is listening on port ${port}`);
    });

  } catch (error) {
    console.error("Error connecting to MongoDB:", error);
  }
}

main();