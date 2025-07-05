import { Request, Response } from 'express';
import { ServiceRecordService } from '../services/serviceRecordService';
import { CreateServiceRecordRequest, ServiceRecordResponse, ServiceRecordsResponse } from '../types/serviceRecord.types';
import { ApiResponse } from '../types/api.types';

export class ServiceRecordController {
  private serviceRecordService: ServiceRecordService;

  constructor() {
    this.serviceRecordService = new ServiceRecordService();
  }

  /**
   * Get all service records for a specific vehicle
   */
  getServiceRecords = async (req: Request, res: Response): Promise<void> => {
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

      const { vehicleId } = req.params;
      if (!vehicleId) {
        const response: ApiResponse = {
          success: false,
          message: 'Vehicle ID is required',
          timestamp: new Date(),
        };
        res.status(400).json(response);
        return;
      }

      const serviceRecords = await this.serviceRecordService.getServiceRecords(vehicleId, req.user.uid);

      const response: ServiceRecordsResponse = {
        success: true,
        message: 'Service records retrieved successfully',
        data: serviceRecords,
        timestamp: new Date(),
      };

      res.status(200).json(response);
    } catch (error: any) {
      const statusCode = error.message.includes('not found') ? 404 : 500;
      const response: ApiResponse = {
        success: false,
        message: error.message || 'Failed to retrieve service records',
        timestamp: new Date(),
      };
      res.status(statusCode).json(response);
    }
  };

  /**
   * Create a new service record for a vehicle
   */
  createServiceRecord = async (req: Request, res: Response): Promise<void> => {
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

      const { vehicleId } = req.params;
      if (!vehicleId) {
        const response: ApiResponse = {
          success: false,
          message: 'Vehicle ID is required',
          timestamp: new Date(),
        };
        res.status(400).json(response);
        return;
      }

      const serviceRecordData: CreateServiceRecordRequest = req.body;

      // Validate required fields
      if (!serviceRecordData.title || !serviceRecordData.description || !serviceRecordData.date || serviceRecordData.mileage === undefined) {
        const response: ApiResponse = {
          success: false,
          message: 'Title, description, date, and mileage are required',
          timestamp: new Date(),
        };
        res.status(400).json(response);
        return;
      }

      const serviceRecord = await this.serviceRecordService.createServiceRecord(
        vehicleId,
        req.user.uid,
        serviceRecordData
      );

      const response: ServiceRecordResponse = {
        success: true,
        message: 'Service record created successfully',
        data: serviceRecord,
        timestamp: new Date(),
      };

      res.status(201).json(response);
    } catch (error: any) {
      const statusCode = error.message.includes('not found') ? 404 :
                        error.message.includes('Invalid') || error.message.includes('required') || error.message.includes('cannot be') ? 400 : 500;
      const response: ApiResponse = {
        success: false,
        message: error.message || 'Failed to create service record',
        timestamp: new Date(),
      };
      res.status(statusCode).json(response);
    }
  };
} 