export interface ServiceRecord {
  id: string;
  vehicleId: string;
  userId: string;
  title: string;
  description: string;
  date: string; // ISO date string
  mileage: number;
  createdAt: Date;
  updatedAt: Date;
}

export interface CreateServiceRecordRequest {
  title: string;
  description: string;
  date: string; // ISO date string
  mileage: number;
}

export interface ServiceRecordResponse {
  success: boolean;
  message: string;
  data?: ServiceRecord;
  timestamp: Date;
}

export interface ServiceRecordsResponse {
  success: boolean;
  message: string;
  data?: ServiceRecord[];
  timestamp: Date;
} 