import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
// import rateLimit from 'express-rate-limit';

// Import routes
import authRoutes from './routes/auth.routes';

// Import middleware
import { errorHandler, notFoundHandler } from './middleware/error.middleware';

// Create Express app
const app = express();

// Security middleware
app.use(helmet());

// CORS configuration
const corsOptions = {
  origin: [
    'http://localhost:3000',
    'http://localhost:8080',
    // Add your Flutter app's URLs here
  ],
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH'],
  allowedHeaders: ['Content-Type', 'Authorization'],
};

app.use(cors(corsOptions));

// Rate limiting disabled for development
// TODO: Re-enable in production with proper IP handling
// const limiter = rateLimit({
//   windowMs: 15 * 60 * 1000, // 15 minutes
//   max: 100, // Limit each IP to 100 requests per windowMs
//   message: {
//     success: false,
//     message: 'Too many requests from this IP, please try again later.',
//     timestamp: new Date(),
//   },
//   standardHeaders: true,
//   legacyHeaders: false,
// });
// app.use(limiter);

// Body parsing middleware
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

// Logging middleware
if (process.env.NODE_ENV !== 'production') {
  app.use(morgan('dev'));
} else {
  app.use(morgan('combined'));
}

// Health check endpoint
app.get('/health', (req, res) => {
  res.status(200).json({
    success: true,
    message: 'WittyCar API is running',
    timestamp: new Date(),
    environment: process.env.NODE_ENV || 'development',
  });
});

// API routes
app.use('/api/v1/auth', authRoutes);

// API info endpoint
app.get('/api/v1', (req, res) => {
  res.status(200).json({
    success: true,
    message: 'WittyCar API v1.0',
    endpoints: {
      auth: '/api/v1/auth',
      health: '/health',
    },
    timestamp: new Date(),
  });
});

// Handle 404 for undefined routes
app.use(notFoundHandler);

// Global error handling middleware (must be last)
app.use(errorHandler);

export default app; 