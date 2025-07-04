import { Request, Response } from 'express';
import { AuthService } from '../services/auth.service';
import { CreateUserRequest, LoginRequest, AuthResponse } from '../types/user.types';
import { ApiResponse } from '../types/api.types';

export class AuthController {
  private authService: AuthService;

  constructor() {
    this.authService = new AuthService();
  }

  /**
   * Register a new user
   */
  register = async (req: Request, res: Response): Promise<void> => {
    try {
      const userData: CreateUserRequest = req.body;

      // Basic validation
      if (!userData.email || !userData.password) {
        const response: ApiResponse = {
          success: false,
          message: 'Email and password are required',
          timestamp: new Date(),
        };
        res.status(400).json(response);
        return;
      }

      // Email validation
      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      if (!emailRegex.test(userData.email)) {
        const response: ApiResponse = {
          success: false,
          message: 'Invalid email format',
          timestamp: new Date(),
        };
        res.status(400).json(response);
        return;
      }

      // Password validation
      if (userData.password.length < 6) {
        const response: ApiResponse = {
          success: false,
          message: 'Password must be at least 6 characters long',
          timestamp: new Date(),
        };
        res.status(400).json(response);
        return;
      }
      console.log("🚀 ~ AuthController ~ register ~ userData:", userData)
      const result = await this.authService.registerUser(userData);

      const response: AuthResponse = {
        success: true,
        message: 'User registered successfully',
        data: result,
      };

      res.status(201).json(response);
    } catch (error: any) {
      const response: ApiResponse = {
        success: false,
        message: error.message || 'Registration failed',
        timestamp: new Date(),
      };
      res.status(400).json(response);
    }
  };

  /**
   * Login user
   */
  login = async (req: Request, res: Response): Promise<void> => {
    try {
      const loginData: LoginRequest = req.body;

      // Basic validation
      if (!loginData.email || !loginData.password) {
        const response: ApiResponse = {
          success: false,
          message: 'Email and password are required',
          timestamp: new Date(),
        };
        res.status(400).json(response);
        return;
      }

      const result = await this.authService.loginUser(loginData);

      const response: AuthResponse = {
        success: true,
        message: 'Login successful',
        data: result,
      };

      res.status(200).json(response);
    } catch (error: any) {
      const response: ApiResponse = {
        success: false,
        message: error.message || 'Login failed',
        timestamp: new Date(),
      };
      res.status(401).json(response);
    }
  };

  /**
   * Get user profile
   */
  getProfile = async (req: Request, res: Response): Promise<void> => {
    try {
      if (!req.user) {
        const response: ApiResponse = {
          success: false,
          message: 'User not authenticated',
          timestamp: new Date(),
        };
        res.status(401).json(response);
        return;
      }

      const user = await this.authService.getUserProfile(req.user.uid);

      const response: ApiResponse = {
        success: true,
        message: 'Profile retrieved successfully',
        data: user,
        timestamp: new Date(),
      };

      res.status(200).json(response);
    } catch (error: any) {
      const response: ApiResponse = {
        success: false,
        message: error.message || 'Failed to get profile',
        timestamp: new Date(),
      };
      res.status(404).json(response);
    }
  };

  /**
   * Update user profile
   */
  updateProfile = async (req: Request, res: Response): Promise<void> => {
    try {
      if (!req.user) {
        const response: ApiResponse = {
          success: false,
          message: 'User not authenticated',
          timestamp: new Date(),
        };
        res.status(401).json(response);
        return;
      }

      const updates = req.body;
      
      // Remove sensitive fields that shouldn't be updated directly
      delete updates.uid;
      delete updates.email;
      delete updates.createdAt;
      delete updates.emailVerified;

      const updatedUser = await this.authService.updateUserProfile(req.user.uid, updates);

      const response: ApiResponse = {
        success: true,
        message: 'Profile updated successfully',
        data: updatedUser,
        timestamp: new Date(),
      };

      res.status(200).json(response);
    } catch (error: any) {
      const response: ApiResponse = {
        success: false,
        message: error.message || 'Failed to update profile',
        timestamp: new Date(),
      };
      res.status(400).json(response);
    }
  };

  /**
   * Verify email
   */
  verifyEmail = async (req: Request, res: Response): Promise<void> => {
    try {
      if (!req.user) {
        const response: ApiResponse = {
          success: false,
          message: 'User not authenticated',
          timestamp: new Date(),
        };
        res.status(401).json(response);
        return;
      }

      await this.authService.verifyEmail(req.user.uid);

      const response: ApiResponse = {
        success: true,
        message: 'Email verified successfully',
        timestamp: new Date(),
      };

      res.status(200).json(response);
    } catch (error: any) {
      const response: ApiResponse = {
        success: false,
        message: error.message || 'Failed to verify email',
        timestamp: new Date(),
      };
      res.status(400).json(response);
    }
  };
} 