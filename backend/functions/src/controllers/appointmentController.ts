import { Request, Response } from 'express';
import { AppointmentService } from '../services/appointmentService';
import { CreateAppointmentRequest, UpdateAppointmentRequest, AppointmentResponse, AppointmentsResponse } from '../types/appointment.types';
import { ApiResponse } from '../types/api.types';

export class AppointmentController {
  private appointmentService: AppointmentService;

  constructor() {
    this.appointmentService = new AppointmentService();
  }

  /**
   * Get all appointments for the authenticated user
   */
  getUserAppointments = async (req: Request, res: Response): Promise<void> => {
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

      const appointments = await this.appointmentService.getUserAppointments(req.user.uid);

      const response: AppointmentsResponse = {
        success: true,
        message: 'Appointments retrieved successfully',
        data: appointments,
        timestamp: new Date(),
      };

      res.status(200).json(response);
    } catch (error: any) {
      const response: ApiResponse = {
        success: false,
        message: error.message || 'Failed to retrieve appointments',
        timestamp: new Date(),
      };
      res.status(500).json(response);
    }
  };

  /**
   * Get a specific appointment by ID
   */
  getAppointmentById = async (req: Request, res: Response): Promise<void> => {
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
          message: 'Appointment ID is required',
          timestamp: new Date(),
        };
        res.status(400).json(response);
        return;
      }

      const appointment = await this.appointmentService.getAppointmentById(id, req.user.uid);

      const response: AppointmentResponse = {
        success: true,
        message: 'Appointment retrieved successfully',
        data: appointment,
        timestamp: new Date(),
      };

      res.status(200).json(response);
    } catch (error: any) {
      const statusCode = error.message.includes('not found') ? 404 : 500;
      const response: ApiResponse = {
        success: false,
        message: error.message || 'Failed to retrieve appointment',
        timestamp: new Date(),
      };
      res.status(statusCode).json(response);
    }
  };

  /**
   * Create a new appointment
   */
  createAppointment = async (req: Request, res: Response): Promise<void> => {
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

      const appointmentData: CreateAppointmentRequest = req.body;

      // Validate required fields
      if (!appointmentData.vehicleId || !appointmentData.date) {
        const response: ApiResponse = {
          success: false,
          message: 'Vehicle ID and date are required',
          timestamp: new Date(),
        };
        res.status(400).json(response);
        return;
      }

      const appointment = await this.appointmentService.createAppointment(req.user.uid, appointmentData);

      const response: AppointmentResponse = {
        success: true,
        message: 'Appointment created successfully',
        data: appointment,
        timestamp: new Date(),
      };

      res.status(201).json(response);
    } catch (error: any) {
      const statusCode = error.message.includes('Time slot already taken') ? 409 : 
                        error.message.includes('not found') ? 404 :
                        error.message.includes('Invalid') || error.message.includes('required') || error.message.includes('must be') ? 400 : 500;
      const response: ApiResponse = {
        success: false,
        message: error.message || 'Failed to create appointment',
        timestamp: new Date(),
      };
      res.status(statusCode).json(response);
    }
  };

  /**
   * Update an appointment
   */
  updateAppointment = async (req: Request, res: Response): Promise<void> => {
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
          message: 'Appointment ID is required',
          timestamp: new Date(),
        };
        res.status(400).json(response);
        return;
      }

      const updates: UpdateAppointmentRequest = req.body;

      // Check if at least one field is provided for update
      if (!updates.vehicleId && !updates.date) {
        const response: ApiResponse = {
          success: false,
          message: 'At least one field must be provided for update',
          timestamp: new Date(),
        };
        res.status(400).json(response);
        return;
      }

      const appointment = await this.appointmentService.updateAppointment(id, req.user.uid, updates);

      const response: AppointmentResponse = {
        success: true,
        message: 'Appointment updated successfully',
        data: appointment,
        timestamp: new Date(),
      };

      res.status(200).json(response);
    } catch (error: any) {
      const statusCode = error.message.includes('not found') ? 404 :
                        error.message.includes('Time slot already taken') ? 409 :
                        error.message.includes('Invalid') || error.message.includes('cannot be') || error.message.includes('must be') ? 400 : 500;
      const response: ApiResponse = {
        success: false,
        message: error.message || 'Failed to update appointment',
        timestamp: new Date(),
      };
      res.status(statusCode).json(response);
    }
  };

  /**
   * Delete an appointment
   */
  deleteAppointment = async (req: Request, res: Response): Promise<void> => {
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
          message: 'Appointment ID is required',
          timestamp: new Date(),
        };
        res.status(400).json(response);
        return;
      }

      await this.appointmentService.deleteAppointment(id, req.user.uid);

      const response: ApiResponse = {
        success: true,
        message: 'Appointment deleted successfully',
        timestamp: new Date(),
      };

      res.status(200).json(response);
    } catch (error: any) {
      const statusCode = error.message.includes('not found') ? 404 : 500;
      const response: ApiResponse = {
        success: false,
        message: error.message || 'Failed to delete appointment',
        timestamp: new Date(),
      };
      res.status(statusCode).json(response);
    }
  };
} 