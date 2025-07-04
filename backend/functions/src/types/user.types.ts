export interface User {
  uid: string;
  email: string;
  displayName?: string;
  phoneNumber?: string;
  emailVerified: boolean;
  createdAt: Date;
  updatedAt: Date;
  isActive: boolean;
}

export interface CreateUserRequest {
  email: string;
  password: string;
  displayName?: string;
  phoneNumber?: string;
}

export interface LoginRequest {
  email: string;
  password: string;
}

export interface AuthResponse {
  success: boolean;
  message: string;
  data?: {
    user: User;
    token: string;
    refreshToken?: string;
  };
}

export interface JWTPayload {
  uid: string;
  email: string;
  iat: number;
  exp: number;
} 