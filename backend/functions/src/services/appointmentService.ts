import { db, COLLECTIONS } from '../config/firebase.config';
import { Appointment, CreateAppointmentRequest, UpdateAppointmentRequest } from '../types/appointment.types';
import { Timestamp } from 'firebase-admin/firestore';

export class AppointmentService {
  /**
   * Get all appointments belonging to a user
   */
  async getUserAppointments(userId: string): Promise<Appointment[]> {
    try {
      const appointmentsSnapshot = await db
        .collection(COLLECTIONS.APPOINTMENTS)
        .where('userId', '==', userId)
        .orderBy('date', 'asc')
        .get();

      const appointments: Appointment[] = [];
      appointmentsSnapshot.forEach((doc) => {
        const data = doc.data();
        appointments.push({
          id: doc.id,
          userId: data.userId,
          vehicleId: data.vehicleId,
          date: data.date,
        });
      });

      return appointments;
    } catch (error: any) {
      console.error('Error getting user appointments:', error);
      throw new Error(`Failed to retrieve appointments: ${error.message}`);
    }
  }

  /**
   * Get a specific appointment by ID (with ownership check)
   */
  async getAppointmentById(appointmentId: string, userId: string): Promise<Appointment> {
    try {
      const appointmentDoc = await db
        .collection(COLLECTIONS.APPOINTMENTS)
        .doc(appointmentId)
        .get();

      if (!appointmentDoc.exists) {
        throw new Error('Appointment not found');
      }

      const data = appointmentDoc.data()!;

      // Check if the appointment belongs to the user
      if (data.userId !== userId) {
        throw new Error('Appointment not found');
      }

      return {
        id: appointmentDoc.id,
        userId: data.userId,
        vehicleId: data.vehicleId,
        date: data.date,
      };
    } catch (error: any) {
      console.error('Error getting appointment by ID:', error);
      throw new Error(`Failed to retrieve appointment: ${error.message}`);
    }
  }

  /**
   * Create a new appointment with transaction to prevent double booking
   */
  async createAppointment(userId: string, appointmentData: CreateAppointmentRequest): Promise<Appointment> {
    try {
      // Validate required fields
      if (!appointmentData.vehicleId || !appointmentData.date) {
        throw new Error('Vehicle ID and date are required');
      }

      // Validate date format and ensure it's in the future
      const appointmentDate = new Date(appointmentData.date);
      if (isNaN(appointmentDate.getTime())) {
        throw new Error('Invalid date format');
      }

      if (appointmentDate <= new Date()) {
        throw new Error('Appointment date must be in the future');
      }

      // Verify user owns the vehicle
      const vehicleDoc = await db
        .collection(COLLECTIONS.VEHICLES)
        .doc(appointmentData.vehicleId)
        .get();

      if (!vehicleDoc.exists) {
        throw new Error('Vehicle not found');
      }

      const vehicleData = vehicleDoc.data()!;
      if (vehicleData.userId !== userId) {
        throw new Error('Vehicle not found');
      }

      // Use transaction to prevent double booking
      const appointment = await db.runTransaction(async (transaction) => {
        // Check if appointment slot is already taken
        const existingAppointmentSnapshot = await transaction.get(
          db.collection(COLLECTIONS.APPOINTMENTS).where('date', '==', appointmentData.date)
        );

        if (!existingAppointmentSnapshot.empty) {
          throw new Error('Time slot already taken');
        }

        // Create appointment document
        const appointmentRef = db.collection(COLLECTIONS.APPOINTMENTS).doc();
        const appointmentDoc = {
          userId: userId,
          vehicleId: appointmentData.vehicleId,
          date: appointmentData.date,
          createdAt: Timestamp.now(),
          updatedAt: Timestamp.now(),
        };

        transaction.set(appointmentRef, appointmentDoc);

        return {
          id: appointmentRef.id,
          userId: appointmentDoc.userId,
          vehicleId: appointmentDoc.vehicleId,
          date: appointmentDoc.date,
        };
      });

      return appointment;
    } catch (error: any) {
      console.error('Error creating appointment:', error);
      throw new Error(`Failed to create appointment: ${error.message}`);
    }
  }

  /**
   * Update an appointment
   */
  async updateAppointment(appointmentId: string, userId: string, updates: UpdateAppointmentRequest): Promise<Appointment> {
    try {
      // First check if appointment exists and belongs to user
      const appointment = await this.getAppointmentById(appointmentId, userId);

      // Validate updates
      if (updates.date) {
        const appointmentDate = new Date(updates.date);
        if (isNaN(appointmentDate.getTime())) {
          throw new Error('Invalid date format');
        }

        if (appointmentDate <= new Date()) {
          throw new Error('Appointment date must be in the future');
        }
      }

      // If updating vehicle, verify user owns it
      if (updates.vehicleId) {
        const vehicleDoc = await db
          .collection(COLLECTIONS.VEHICLES)
          .doc(updates.vehicleId)
          .get();

        if (!vehicleDoc.exists) {
          throw new Error('Vehicle not found');
        }

        const vehicleData = vehicleDoc.data()!;
        if (vehicleData.userId !== userId) {
          throw new Error('Vehicle not found');
        }
      }

      // Use transaction to prevent double booking if date is being updated
      const updatedAppointment = await db.runTransaction(async (transaction) => {
        // If date is being updated, check for conflicts
        if (updates.date && updates.date !== appointment.date) {
          const existingAppointmentSnapshot = await transaction.get(
            db.collection(COLLECTIONS.APPOINTMENTS).where('date', '==', updates.date)
          );

          if (!existingAppointmentSnapshot.empty) {
            throw new Error('Time slot already taken');
          }
        }

        // Build update object
        const updateData: any = {
          updatedAt: Timestamp.now(),
        };

        if (updates.vehicleId) updateData.vehicleId = updates.vehicleId;
        if (updates.date) updateData.date = updates.date;

        // Update the appointment
        transaction.update(db.collection(COLLECTIONS.APPOINTMENTS).doc(appointmentId), updateData);

        return {
          id: appointmentId,
          userId: appointment.userId,
          vehicleId: updates.vehicleId || appointment.vehicleId,
          date: updates.date || appointment.date,
        };
      });

      return updatedAppointment;
    } catch (error: any) {
      console.error('Error updating appointment:', error);
      throw new Error(`Failed to update appointment: ${error.message}`);
    }
  }

  /**
   * Delete an appointment
   */
  async deleteAppointment(appointmentId: string, userId: string): Promise<void> {
    try {
      // First check if appointment exists and belongs to user
      await this.getAppointmentById(appointmentId, userId);

      // Delete the appointment
      await db.collection(COLLECTIONS.APPOINTMENTS).doc(appointmentId).delete();
    } catch (error: any) {
      console.error('Error deleting appointment:', error);
      throw new Error(`Failed to delete appointment: ${error.message}`);
    }
  }
} 