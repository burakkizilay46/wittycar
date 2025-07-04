import { Request, Response } from 'express';
import { VehicleService } from '../services/vehicleService';
import { CreateVehicleRequest, UpdateVehicleRequest, VehicleResponse, VehiclesResponse } from '../types/vehicle.types';
import { ApiResponse } from '../types/api.types';

export class VehiclesController {
  private vehicleService: VehicleService;

  constructor() {
    this.vehicleService = new VehicleService();
  }

  /**
   * Get all vehicles for the authenticated user
   */
  getUserVehicles = async (req: Request, res: Response): Promise<void> => {
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

      const vehicles = await this.vehicleService.getUserVehicles(req.user.uid);

      const response: VehiclesResponse = {
        success: true,
        message: 'Vehicles retrieved successfully',
        data: vehicles,
        timestamp: new Date(),
      };

      res.status(200).json(response);
    } catch (error: any) {
      const response: ApiResponse = {
        success: false,
        message: error.message || 'Failed to retrieve vehicles',
        timestamp: new Date(),
      };
      res.status(500).json(response);
    }
  };

  /**
   * Get a specific vehicle by ID
   */
  getVehicleById = async (req: Request, res: Response): Promise<void> => {
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

      const { id } = req.params;
      if (!id) {
        const response: ApiResponse = {
          success: false,
          message: 'Vehicle ID is required',
          timestamp: new Date(),
        };
        res.status(400).json(response);
        return;
      }

      const vehicle = await this.vehicleService.getVehicleById(id, req.user.uid);

      const response: VehicleResponse = {
        success: true,
        message: 'Vehicle retrieved successfully',
        data: vehicle,
        timestamp: new Date(),
      };

      res.status(200).json(response);
    } catch (error: any) {
      const statusCode = error.message.includes('not found') ? 404 : 500;
      const response: ApiResponse = {
        success: false,
        message: error.message || 'Failed to retrieve vehicle',
        timestamp: new Date(),
      };
      res.status(statusCode).json(response);
    }
  };

  /**
   * Create a new vehicle
   */
  createVehicle = async (req: Request, res: Response): Promise<void> => {
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

      const vehicleData: CreateVehicleRequest = req.body;

      // Validate required fields
      if (!vehicleData.plate || !vehicleData.brand || !vehicleData.model || !vehicleData.year || vehicleData.mileage === undefined) {
        const response: ApiResponse = {
          success: false,
          message: 'Plate, brand, model, year, and mileage are required',
          timestamp: new Date(),
        };
        res.status(400).json(response);
        return;
      }

      const vehicle = await this.vehicleService.createVehicle(req.user.uid, vehicleData);

      const response: VehicleResponse = {
        success: true,
        message: 'Vehicle created successfully',
        data: vehicle,
        timestamp: new Date(),
      };

      res.status(201).json(response);
    } catch (error: any) {
      const statusCode = error.message.includes('already exists') ? 409 : 
                        error.message.includes('Invalid') || error.message.includes('required') ? 400 : 500;
      const response: ApiResponse = {
        success: false,
        message: error.message || 'Failed to create vehicle',
        timestamp: new Date(),
      };
      res.status(statusCode).json(response);
    }
  };

  /**
   * Update a vehicle
   */
  updateVehicle = async (req: Request, res: Response): Promise<void> => {
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

      const { id } = req.params;
      if (!id) {
        const response: ApiResponse = {
          success: false,
          message: 'Vehicle ID is required',
          timestamp: new Date(),
        };
        res.status(400).json(response);
        return;
      }

      const updates: UpdateVehicleRequest = req.body;

      // Check if at least one field is provided for update
      if (!updates.plate && !updates.brand && !updates.model && !updates.year && updates.mileage === undefined) {
        const response: ApiResponse = {
          success: false,
          message: 'At least one field must be provided for update',
          timestamp: new Date(),
        };
        res.status(400).json(response);
        return;
      }

      const vehicle = await this.vehicleService.updateVehicle(id, req.user.uid, updates);

      const response: VehicleResponse = {
        success: true,
        message: 'Vehicle updated successfully',
        data: vehicle,
        timestamp: new Date(),
      };

      res.status(200).json(response);
    } catch (error: any) {
      const statusCode = error.message.includes('not found') ? 404 :
                        error.message.includes('already exists') ? 409 :
                        error.message.includes('Invalid') || error.message.includes('cannot be') ? 400 : 500;
      const response: ApiResponse = {
        success: false,
        message: error.message || 'Failed to update vehicle',
        timestamp: new Date(),
      };
      res.status(statusCode).json(response);
    }
  };

  /**
   * Delete a vehicle
   */
  deleteVehicle = async (req: Request, res: Response): Promise<void> => {
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

      const { id } = req.params;
      if (!id) {
        const response: ApiResponse = {
          success: false,
          message: 'Vehicle ID is required',
          timestamp: new Date(),
        };
        res.status(400).json(response);
        return;
      }

      await this.vehicleService.deleteVehicle(id, req.user.uid);

      const response: ApiResponse = {
        success: true,
        message: 'Vehicle deleted successfully',
        timestamp: new Date(),
      };

      res.status(200).json(response);
    } catch (error: any) {
      const statusCode = error.message.includes('not found') ? 404 : 500;
      const response: ApiResponse = {
        success: false,
        message: error.message || 'Failed to delete vehicle',
        timestamp: new Date(),
      };
      res.status(statusCode).json(response);
    }
  };
} 