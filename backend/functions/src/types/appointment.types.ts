export interface Appointment {
  id?: string;
  userId: string;
  vehicleId: string;
  date: string; // ISO string (e.g. "2025-07-10T15:30:00Z")
}

export interface CreateAppointmentRequest {
  vehicleId: string;
  date: string; // ISO string (e.g. "2025-07-10T15:30:00Z")
}

export interface UpdateAppointmentRequest {
  vehicleId?: string;
  date?: string;
}

export interface AppointmentResponse {
  success: boolean;
  message: string;
  data?: Appointment;
  timestamp: Date;
}

export interface AppointmentsResponse {
  success: boolean;
  message: string;
  data?: Appointment[];
  timestamp: Date;
} 