import { Router } from 'express';
import { AuthController } from '../controllers/auth.controller';
import { authenticateToken } from '../middleware/auth.middleware';
import { asyncHandler } from '../middleware/error.middleware';

const router = Router();
const authController = new AuthController();

/**
 * @route   POST /auth/register
 * @desc    Register a new user
 * @access  Public
 */
router.post('/register', asyncHandler(authController.register));

/**
 * @route   POST /auth/login
 * @desc    Login user and get token
 * @access  Public
 */
router.post('/login', asyncHandler(authController.login));

/**
 * @route   GET /auth/profile
 * @desc    Get current user profile
 * @access  Private
 */
router.get('/profile', authenticateToken, asyncHandler(authController.getProfile));

/**
 * @route   PUT /auth/profile
 * @desc    Update user profile
 * @access  Private
 */
router.put('/profile', authenticateToken, asyncHandler(authController.updateProfile));

/**
 * @route   POST /auth/verify-email
 * @desc    Verify user email
 * @access  Private
 */
router.post('/verify-email', authenticateToken, asyncHandler(authController.verifyEmail));

export default router; 