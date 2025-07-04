export interface ApiResponse<T = any> {
  success: boolean;
  message: string;
  data?: T;
  error?: string;
  timestamp: Date;
}

export interface PaginatedResponse<T> extends ApiResponse<T[]> {
  pagination: {
    page: number;
    limit: number;
    total: number;
    totalPages: number;
  };
}

export interface ValidationError {
  field: string;
  message: string;
}

export interface ErrorResponse extends ApiResponse {
  errors?: ValidationError[];
  stack?: string;
}

// Vehicle-related types for future expansion
export interface Vehicle {
  id: string;
  userId: string;
  make: string;
  model: string;
  year: number;
  vin?: string;
  licensePlate: string;
  mileage: number;
  createdAt: Date;
  updatedAt: Date;
}

export interface MaintenanceRecord {
  id: string;
  vehicleId: string;
  type: string;
  description: string;
  cost: number;
  mileage: number;
  serviceDate: Date;
  nextServiceMileage?: number;
  nextServiceDate?: Date;
  createdAt: Date;
  updatedAt: Date;
} 