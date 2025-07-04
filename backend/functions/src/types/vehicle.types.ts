export interface Vehicle {
  id: string;
  userId: string;
  plate: string;
  brand: string;
  model: string;
  year: number;
  mileage: number;
  createdAt: Date;
  updatedAt: Date;
}

export interface CreateVehicleRequest {
  plate: string;
  brand: string;
  model: string;
  year: number;
  mileage: number;
}

export interface UpdateVehicleRequest {
  plate?: string;
  brand?: string;
  model?: string;
  year?: number;
  mileage?: number;
}

export interface VehicleResponse {
  success: boolean;
  message: string;
  data?: Vehicle;
  timestamp: Date;
}

export interface VehiclesResponse {
  success: boolean;
  message: string;
  data?: Vehicle[];
  timestamp: Date;
} 