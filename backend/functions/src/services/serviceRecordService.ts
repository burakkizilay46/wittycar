import { db, COLLECTIONS } from '../config/firebase.config';
import { ServiceRecord, CreateServiceRecordRequest } from '../types/serviceRecord.types';
import { Timestamp } from 'firebase-admin/firestore';
import { VehicleService } from './vehicleService';

export class ServiceRecordService {
  private vehicleService: VehicleService;

  constructor() {
    this.vehicleService = new VehicleService();
  }

  /**
   * Get all service records for a specific vehicle belonging to a user
   */
  async getServiceRecords(vehicleId: string, userId: string): Promise<ServiceRecord[]> {
    try {
      // First verify that the vehicle belongs to the user
      await this.vehicleService.getVehicleById(vehicleId, userId);

      const serviceRecordsSnapshot = await db
        .collection(COLLECTIONS.SERVICE_RECORDS)
        .where('vehicleId', '==', vehicleId)
        .where('userId', '==', userId)
        .orderBy('date', 'desc')
        .get();

      const serviceRecords: ServiceRecord[] = [];
      serviceRecordsSnapshot.forEach((doc) => {
        const data = doc.data();
        serviceRecords.push({
          id: doc.id,
          vehicleId: data.vehicleId,
          userId: data.userId,
          title: data.title,
          description: data.description,
          date: data.date,
          mileage: data.mileage,
          createdAt: data.createdAt.toDate(),
          updatedAt: data.updatedAt.toDate(),
        });
      });

      return serviceRecords;
    } catch (error: any) {
      console.error('Error getting service records:', error);
      throw new Error(`Failed to retrieve service records: ${error.message}`);
    }
  }

  /**
   * Create a new service record for a vehicle
   */
  async createServiceRecord(
    vehicleId: string,
    userId: string,
    serviceRecordData: CreateServiceRecordRequest
  ): Promise<ServiceRecord> {
    try {
      // First verify that the vehicle belongs to the user
      await this.vehicleService.getVehicleById(vehicleId, userId);

      // Validate required fields
      if (!serviceRecordData.title || !serviceRecordData.description) {
        throw new Error('Title and description are required');
      }

      if (!serviceRecordData.date) {
        throw new Error('Date is required');
      }

      if (serviceRecordData.mileage < 0) {
        throw new Error('Mileage cannot be negative');
      }

      // Validate date format
      let parsedDate: Date;
      try {
        parsedDate = new Date(serviceRecordData.date);
        if (isNaN(parsedDate.getTime())) {
          throw new Error('Invalid date format');
        }
      } catch {
        throw new Error('Invalid date format. Please use ISO format (e.g., "2025-07-05T14:30:00Z")');
      }

      const now = Timestamp.now();
      const serviceRecordDoc = {
        vehicleId: vehicleId,
        userId: userId,
        title: serviceRecordData.title.trim(),
        description: serviceRecordData.description.trim(),
        date: serviceRecordData.date,
        mileage: serviceRecordData.mileage,
        createdAt: now,
        updatedAt: now,
      };

      const docRef = await db.collection(COLLECTIONS.SERVICE_RECORDS).add(serviceRecordDoc);

      return {
        id: docRef.id,
        vehicleId: serviceRecordDoc.vehicleId,
        userId: serviceRecordDoc.userId,
        title: serviceRecordDoc.title,
        description: serviceRecordDoc.description,
        date: serviceRecordDoc.date,
        mileage: serviceRecordDoc.mileage,
        createdAt: serviceRecordDoc.createdAt.toDate(),
        updatedAt: serviceRecordDoc.updatedAt.toDate(),
      };
    } catch (error: any) {
      console.error('Error creating service record:', error);
      throw new Error(`Failed to create service record: ${error.message}`);
    }
  }
} 