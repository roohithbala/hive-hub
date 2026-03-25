require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const rateLimit = require('express-rate-limit');

const { MONGODB_URI, PORT } = require('./config');

const app = express();
app.use(express.json());
app.use(cors());

const apiLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 100,
  standardHeaders: true,
  legacyHeaders: false
});

app.use('/api', apiLimiter);

// Serve static files from the 'uploads' directory
app.use('/uploads', express.static('uploads'));

app.get('/health', (req, res) => {
  res.status(200).json({ status: 'ok' });
});

// Import routes
const authRoutes = require('./routes/auth');
const appointmentRoutes = require('./routes/appointments');
const productRoutes = require('./routes/products'); // Ensure this line exists
const adminRoutes = require('./routes/admin');
const orderRoutes = require('./routes/orders');
const usersRoutes = require('./routes/users');

app.use('/api/auth', authRoutes);
app.use('/api/appointments', appointmentRoutes);
app.use('/api/products', productRoutes);
app.use('/api/admin', adminRoutes);
app.use('/api/orders', orderRoutes);
app.use('/api/users', usersRoutes);

// Connect to MongoDB
console.log(`Connecting to MongoDB at: ${MONGODB_URI}`);
console.log(`Server will run on port: ${PORT}`);

mongoose.connect(MONGODB_URI, { serverSelectionTimeoutMS: 20000 })
  .then(() => {
    console.log('✅ MongoDB connected successfully');
    app.listen(PORT, () => {
      console.log(`🚀 Server running on port ${PORT}`);
      console.log(`🌐 Frontend should be accessible via nginx on port 80`);
    });
  })
  .catch(err => {
    console.error('❌ MongoDB connection failed:', err.message);
    console.error('Full error:', err);
    process.exit(1);
  });
