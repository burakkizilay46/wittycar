import { Router } from 'express';
import { VehiclesController } from '../controllers/vehiclesController';
import { authenticateToken } from '../middleware/auth.middleware';
import { asyncHandler } from '../middleware/error.middleware';

const router = Router();
const vehiclesController = new VehiclesController();

/**
 * @route   GET /vehicles
 * @desc    Get all vehicles for the authenticated user
 * @access  Private
 */
router.get('/', authenticateToken, asyncHandler(vehiclesController.getUserVehicles));

/**
 * @route   POST /vehicles
 * @desc    Create a new vehicle
 * @access  Private
 */
router.post('/', authenticateToken, asyncHandler(vehiclesController.createVehicle));

/**
 * @route   GET /vehicles/:id
 * @desc    Get a specific vehicle by ID
 * @access  Private
 */
router.get('/:id', authenticateToken, asyncHandler(vehiclesController.getVehicleById));

/**
 * @route   PUT /vehicles/:id
 * @desc    Update a vehicle
 * @access  Private
 */
router.put('/:id', authenticateToken, asyncHandler(vehiclesController.updateVehicle));

/**
 * @route   DELETE /vehicles/:id
 * @desc    Delete a vehicle
 * @access  Private
 */
router.delete('/:id', authenticateToken, asyncHandler(vehiclesController.deleteVehicle));

export default router; 