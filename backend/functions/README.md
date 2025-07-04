# WittyCar Backend API

A Firebase Cloud Functions backend for a vehicle maintenance and service tracking application.

## Features

- 🔐 JWT-based authentication with Firebase Auth
- 🚗 Vehicle maintenance tracking
- 📱 RESTful API for Flutter frontend
- ⚡ Firebase Cloud Functions deployment
- 🔥 Firestore database integration
- 🛡️ Security middleware (Helmet, CORS, Rate limiting)
- 📊 Request logging and error handling

## Tech Stack

- **Runtime**: Node.js 22
- **Language**: TypeScript
- **Framework**: Express.js
- **Database**: Firestore (NoSQL)
- **Authentication**: Firebase Auth + JWT
- **Deployment**: Firebase Cloud Functions
- **Package Manager**: Yarn

## Project Structure

```
functions/
├── src/
│   ├── config/           # Firebase and app configuration
│   ├── controllers/      # Request handlers
│   ├── middleware/       # Custom middleware
│   ├── routes/          # API route definitions
│   ├── services/        # Business logic
│   ├── types/           # TypeScript interfaces
│   ├── utils/           # Helper functions
│   ├── app.ts           # Express app setup
│   └── index.ts         # Firebase Functions entry point
├── package.json
└── README.md
```

## Getting Started

### Prerequisites

- Node.js 22+ (recommended to use nvm)
- Yarn package manager
- Firebase CLI
- Firebase project with Firestore and Authentication enabled

### Installation

1. **Install dependencies**:
   ```bash
   cd functions
   yarn install
   ```

2. **Set up environment variables**:
   ```bash
   # Create .env file (use .env.example as template)
   cp .env.example .env
   
   # Update with your Firebase project configuration
   ```

3. **Start development server**:
   ```bash
   yarn serve
   ```

4. **Build for production**:
   ```bash
   yarn build
   ```

### Development Commands

```bash
# Install dependencies
yarn install

# Start Firebase emulator for local development
yarn serve

# Build TypeScript
yarn build

# Watch mode for development
yarn build:watch

# Run linting
yarn lint

# Deploy to Firebase
yarn deploy

# View function logs
yarn logs
```

## API Endpoints

### Base URL
- **Local**: `http://localhost:5001/{project-id}/us-central1/api`
- **Production**: `https://us-central1-{project-id}.cloudfunctions.net/api`

### Authentication Routes

| Method | Endpoint | Description | Access |
|--------|----------|-------------|---------|
| POST | `/api/v1/auth/register` | Register new user | Public |
| POST | `/api/v1/auth/login` | User login | Public |
| GET | `/api/v1/auth/profile` | Get user profile | Private |
| PUT | `/api/v1/auth/profile` | Update user profile | Private |
| POST | `/api/v1/auth/verify-email` | Verify user email | Private |

### Health Check

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/health` | API health status |
| GET | `/api/v1` | API information |

## API Usage Examples

### Register User
```bash
curl -X POST https://your-api-url/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "password123",
    "displayName": "John Doe"
  }'
```

### Login User
```bash
curl -X POST https://your-api-url/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "password123"
  }'
```

### Get Profile (Protected)
```bash
curl -X GET https://your-api-url/api/v1/auth/profile \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

## Response Format

All API responses follow this consistent format:

```json
{
  "success": true,
  "message": "Operation completed successfully",
  "data": { /* response data */ },
  "timestamp": "2024-01-01T00:00:00.000Z"
}
```

## Environment Variables

```bash
# Firebase Configuration
FIREBASE_PROJECT_ID=your-project-id
JWT_SECRET=your-jwt-secret-key
JWT_EXPIRES_IN=24h
NODE_ENV=development
```

## Deployment

1. **Build the project**:
   ```bash
   yarn build
   ```

2. **Deploy to Firebase**:
   ```bash
   yarn deploy
   ```

3. **Deploy specific functions**:
   ```bash
   firebase deploy --only functions:api
   ```

## Security Features

- JWT token authentication
- Password validation (minimum 6 characters)
- Email format validation
- Rate limiting (100 requests per 15 minutes)
- CORS protection
- Security headers with Helmet
- Input sanitization
- Error handling middleware

## Firestore Collections

- `users` - User profiles and account information
- `vehicles` - Vehicle data for each user
- `maintenanceRecords` - Service and maintenance history
- `serviceReminders` - Upcoming service notifications

## Contributing

1. Follow TypeScript best practices
2. Use consistent error handling
3. Add proper JSDoc comments
4. Test locally before deployment
5. Update this README for new features

## License

This project is part of the WittyCar application. 