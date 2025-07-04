import { Request, Response, NextFunction } from 'express';
import { verifyToken, extractTokenFromHeader } from '../utils/jwt.utils';
import { auth } from '../config/firebase.config';
import { ApiResponse } from '../types/api.types';

// Extend Request interface to include user
declare global {
  namespace Express {
    interface Request {
      user?: {
        uid: string;
        email: string;
      };
    }
  }
}

/**
 * Middleware to authenticate JWT tokens
 */
export const authenticateToken = async (
  req: Request,
  res: Response,
  next: NextFunction
): Promise<void> => {
  try {
    const token = extractTokenFromHeader(req.headers.authorization);
    
    if (!token) {
      const response: ApiResponse = {
        success: false,
        message: 'Access token is required',
        timestamp: new Date(),
      };
      res.status(401).json(response);
      return;
    }

    // Verify JWT token
    const decoded = verifyToken(token);
    
    // Verify user exists in Firebase Auth
    const userRecord = await auth.getUser(decoded.uid);
    
    if (!userRecord) {
      const response: ApiResponse = {
        success: false,
        message: 'User not found',
        timestamp: new Date(),
      };
      res.status(401).json(response);
      return;
    }

    // Add user info to request
    req.user = {
      uid: userRecord.uid,
      email: userRecord.email || decoded.email,
    };

    next();
  } catch (error) {
    console.error('Authentication error:', error);
    
    const response: ApiResponse = {
      success: false,
      message: 'Invalid or expired token',
      timestamp: new Date(),
    };
    res.status(401).json(response);
  }
};

/**
 * Optional authentication middleware - sets user if token is valid, but doesn't block
 */
export const optionalAuth = async (
  req: Request,
  res: Response,
  next: NextFunction
): Promise<void> => {
  try {
    const token = extractTokenFromHeader(req.headers.authorization);
    
    if (token) {
      const decoded = verifyToken(token);
      const userRecord = await auth.getUser(decoded.uid);
      
      if (userRecord) {
        req.user = {
          uid: userRecord.uid,
          email: userRecord.email || decoded.email,
        };
      }
    }
  } catch (error) {
    // Silently fail for optional auth
    console.warn('Optional auth failed:', error);
  }
  
  next();
}; 