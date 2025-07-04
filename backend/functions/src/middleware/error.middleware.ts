import { Request, Response, NextFunction } from 'express';
import { ErrorResponse, ValidationError } from '../types/api.types';

/**
 * Global error handling middleware
 */
export const errorHandler = (
  error: any,
  req: Request,
  res: Response,
  next: NextFunction
): void => {
  console.error('Error occurred:', {
    message: error.message,
    stack: error.stack,
    url: req.url,
    method: req.method,
    timestamp: new Date().toISOString(),
  });

  // Default error response
  let statusCode = 500;
  let message = 'Internal server error';
  const errors: ValidationError[] = [];

  // Handle specific error types
  if (error.name === 'ValidationError') {
    statusCode = 400;
    message = 'Validation failed';
    
    // Parse validation errors if available
    if (error.errors) {
      Object.keys(error.errors).forEach((field) => {
        errors.push({
          field,
          message: error.errors[field].message,
        });
      });
    }
  } else if (error.name === 'UnauthorizedError' || error.message.includes('token')) {
    statusCode = 401;
    message = 'Unauthorized access';
  } else if (error.name === 'ForbiddenError') {
    statusCode = 403;
    message = 'Forbidden access';
  } else if (error.name === 'NotFoundError') {
    statusCode = 404;
    message = 'Resource not found';
  } else if (error.message) {
    message = error.message;
    
    // Set appropriate status code based on message
    if (error.message.includes('not found')) {
      statusCode = 404;
    } else if (error.message.includes('unauthorized') || error.message.includes('Invalid token')) {
      statusCode = 401;
    } else if (error.message.includes('forbidden')) {
      statusCode = 403;
    } else if (error.message.includes('validation') || error.message.includes('required')) {
      statusCode = 400;
    }
  }

  const errorResponse: ErrorResponse = {
    success: false,
    message,
    timestamp: new Date(),
    ...(errors.length > 0 && { errors }),
    ...(process.env.NODE_ENV === 'development' && { stack: error.stack }),
  };

  res.status(statusCode).json(errorResponse);
};

/**
 * Handle 404 errors for undefined routes
 */
export const notFoundHandler = (
  req: Request,
  res: Response,
  next: NextFunction
): void => {
  const errorResponse: ErrorResponse = {
    success: false,
    message: `Route ${req.method} ${req.path} not found`,
    timestamp: new Date(),
  };

  res.status(404).json(errorResponse);
};

/**
 * Async error wrapper to catch errors in async route handlers
 */
export const asyncHandler = (fn: Function) => {
  return (req: Request, res: Response, next: NextFunction) => {
    Promise.resolve(fn(req, res, next)).catch(next);
  };
}; 