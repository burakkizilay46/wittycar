import { Router } from 'express';
import { AppointmentController } from '../controllers/appointmentController';
import { authenticateToken } from '../middleware/auth.middleware';
import { asyncHandler } from '../middleware/error.middleware';

const router = Router();
const appointmentController = new AppointmentController();

/**
 * @route   GET /appointments
 * @desc    Get all appointments for the authenticated user
 * @access  Private
 */
router.get('/', authenticateToken, asyncHandler(appointmentController.getUserAppointments));

/**
 * @route   GET /appointments/:id
 * @desc    Get a specific appointment by ID
 * @access  Private
 */
router.get('/:id', authenticateToken, asyncHandler(appointmentController.getAppointmentById));

/**
 * @route   POST /appointments
 * @desc    Create a new appointment
 * @access  Private
 */
router.post('/', authenticateToken, asyncHandler(appointmentController.createAppointment));

/**
 * @route   PUT /appointments/:id
 * @desc    Update an appointment
 * @access  Private
 */
router.put('/:id', authenticateToken, asyncHandler(appointmentController.updateAppointment));

/**
 * @route   DELETE /appointments/:id
 * @desc    Delete an appointment
 * @access  Private
 */
router.delete('/:id', authenticateToken, asyncHandler(appointmentController.deleteAppointment));

export default router; 