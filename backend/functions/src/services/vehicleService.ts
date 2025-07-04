import { db, COLLECTIONS } from '../config/firebase.config';
import { Vehicle, CreateVehicleRequest, UpdateVehicleRequest } from '../types/vehicle.types';
import { Timestamp } from 'firebase-admin/firestore';

export class VehicleService {
  /**
   * Get all vehicles belonging to a user
   */
  async getUserVehicles(userId: string): Promise<Vehicle[]> {
    try {
      const vehiclesSnapshot = await db
        .collection(COLLECTIONS.VEHICLES)
        .where('userId', '==', userId)
        .orderBy('createdAt', 'desc')
        .get();

      const vehicles: Vehicle[] = [];
      vehiclesSnapshot.forEach((doc) => {
        const data = doc.data();
        vehicles.push({
          id: doc.id,
          userId: data.userId,
          plate: data.plate,
          brand: data.brand,
          model: data.model,
          year: data.year,
          mileage: data.mileage,
          createdAt: data.createdAt.toDate(),
          updatedAt: data.updatedAt.toDate(),
        });
      });

      return vehicles;
    } catch (error: any) {
      console.error('Error getting user vehicles:', error);
      throw new Error(`Failed to retrieve vehicles: ${error.message}`);
    }
  }

  /**
   * Get a specific vehicle by ID (with ownership check)
   */
  async getVehicleById(vehicleId: string, userId: string): Promise<Vehicle> {
    try {
      const vehicleDoc = await db
        .collection(COLLECTIONS.VEHICLES)
        .doc(vehicleId)
        .get();

      if (!vehicleDoc.exists) {
        throw new Error('Vehicle not found');
      }

      const data = vehicleDoc.data()!;

      // Check if the vehicle belongs to the user
      if (data.userId !== userId) {
        throw new Error('Vehicle not found');
      }

      return {
        id: vehicleDoc.id,
        userId: data.userId,
        plate: data.plate,
        brand: data.brand,
        model: data.model,
        year: data.year,
        mileage: data.mileage,
        createdAt: data.createdAt.toDate(),
        updatedAt: data.updatedAt.toDate(),
      };
    } catch (error: any) {
      console.error('Error getting vehicle by ID:', error);
      throw new Error(`Failed to retrieve vehicle: ${error.message}`);
    }
  }

  /**
   * Create a new vehicle
   */
  async createVehicle(userId: string, vehicleData: CreateVehicleRequest): Promise<Vehicle> {
    try {
      // Validate required fields
      if (!vehicleData.plate || !vehicleData.brand || !vehicleData.model) {
        throw new Error('Plate, brand, and model are required');
      }

      if (vehicleData.year < 1900 || vehicleData.year > new Date().getFullYear() + 1) {
        throw new Error('Invalid year');
      }

      if (vehicleData.mileage < 0) {
        throw new Error('Mileage cannot be negative');
      }

      // Check if plate already exists for this user
      const existingVehicleSnapshot = await db
        .collection(COLLECTIONS.VEHICLES)
        .where('userId', '==', userId)
        .where('plate', '==', vehicleData.plate.trim().toUpperCase())
        .get();

      if (!existingVehicleSnapshot.empty) {
        throw new Error('A vehicle with this plate already exists');
      }

      const now = Timestamp.now();
      const vehicleDoc = {
        userId: userId,
        plate: vehicleData.plate.trim().toUpperCase(),
        brand: vehicleData.brand.trim(),
        model: vehicleData.model.trim(),
        year: vehicleData.year,
        mileage: vehicleData.mileage,
        createdAt: now,
        updatedAt: now,
      };

      const docRef = await db.collection(COLLECTIONS.VEHICLES).add(vehicleDoc);

      return {
        id: docRef.id,
        userId: vehicleDoc.userId,
        plate: vehicleDoc.plate,
        brand: vehicleDoc.brand,
        model: vehicleDoc.model,
        year: vehicleDoc.year,
        mileage: vehicleDoc.mileage,
        createdAt: vehicleDoc.createdAt.toDate(),
        updatedAt: vehicleDoc.updatedAt.toDate(),
      };
    } catch (error: any) {
      console.error('Error creating vehicle:', error);
      throw new Error(`Failed to create vehicle: ${error.message}`);
    }
  }

  /**
   * Update a vehicle
   */
  async updateVehicle(vehicleId: string, userId: string, updates: UpdateVehicleRequest): Promise<Vehicle> {
    try {
      // First check if vehicle exists and belongs to user
      const vehicle = await this.getVehicleById(vehicleId, userId);

      // Validate updates
      if (updates.year && (updates.year < 1900 || updates.year > new Date().getFullYear() + 1)) {
        throw new Error('Invalid year');
      }

      if (updates.mileage !== undefined && updates.mileage < 0) {
        throw new Error('Mileage cannot be negative');
      }

      // Check if plate update conflicts with existing vehicle
      if (updates.plate && updates.plate.trim().toUpperCase() !== vehicle.plate) {
        const existingVehicleSnapshot = await db
          .collection(COLLECTIONS.VEHICLES)
          .where('userId', '==', userId)
          .where('plate', '==', updates.plate.trim().toUpperCase())
          .get();

        if (!existingVehicleSnapshot.empty) {
          throw new Error('A vehicle with this plate already exists');
        }
      }

      // Build update object
      const updateData: any = {
        updatedAt: Timestamp.now(),
      };

      if (updates.plate) updateData.plate = updates.plate.trim().toUpperCase();
      if (updates.brand) updateData.brand = updates.brand.trim();
      if (updates.model) updateData.model = updates.model.trim();
      if (updates.year) updateData.year = updates.year;
      if (updates.mileage !== undefined) updateData.mileage = updates.mileage;

      // Update the vehicle
      await db.collection(COLLECTIONS.VEHICLES).doc(vehicleId).update(updateData);

      // Return updated vehicle
      return await this.getVehicleById(vehicleId, userId);
    } catch (error: any) {
      console.error('Error updating vehicle:', error);
      throw new Error(`Failed to update vehicle: ${error.message}`);
    }
  }

  /**
   * Delete a vehicle
   */
  async deleteVehicle(vehicleId: string, userId: string): Promise<void> {
    try {
      // First check if vehicle exists and belongs to user
      await this.getVehicleById(vehicleId, userId);

      // Delete the vehicle
      await db.collection(COLLECTIONS.VEHICLES).doc(vehicleId).delete();
    } catch (error: any) {
      console.error('Error deleting vehicle:', error);
      throw new Error(`Failed to delete vehicle: ${error.message}`);
    }
  }
} 