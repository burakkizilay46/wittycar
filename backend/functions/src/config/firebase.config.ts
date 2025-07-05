import * as admin from 'firebase-admin';
import { getFirestore } from 'firebase-admin/firestore';
import { getAuth } from 'firebase-admin/auth';

// Initialize Firebase Admin SDK
if (!admin.apps.length) {
  const isEmulator = process.env.FUNCTIONS_EMULATOR === 'true';
  
  if (isEmulator) {
    // Emulator mode - use default credentials
    admin.initializeApp({
      projectId: process.env.FIREBASE_PROJECT_ID || 'wittycar-996ea',
    });
    
    // Set Auth emulator host
    process.env.FIREBASE_AUTH_EMULATOR_HOST = 'localhost:9099';
  } else {
    // Production mode - use application default credentials
    admin.initializeApp({
      credential: admin.credential.applicationDefault(),
      projectId: process.env.FIREBASE_PROJECT_ID || 'wittycar-996ea',
    });
  }
}

// Export Firebase services
export const db = getFirestore();
export const auth = getAuth();
export const adminApp = admin.app();

// Configure Firestore to ignore undefined properties
try {
  const isEmulator = process.env.FUNCTIONS_EMULATOR === 'true';
  
  if (isEmulator) {
    // Use emulator port from firebase.json
    db.settings({
      host: 'localhost:8081',
      ssl: false,
      ignoreUndefinedProperties: true
    });
    console.log('🔧 Firestore configured for emulator mode (localhost:8081)');
  } else {
    // Production settings
    db.settings({
      ignoreUndefinedProperties: true
    });
    console.log('🔧 Firestore configured for production mode');
  }
} catch (error) {
  console.warn('Failed to set Firestore settings:', error);
}

// Helper function to verify Firebase is initialized
export const isFirebaseInitialized = (): boolean => {
  return admin.apps.length > 0;
};

// Firestore collections
export const COLLECTIONS = {
  USERS: 'users',
  VEHICLES: 'vehicles',
  MAINTENANCE_RECORDS: 'maintenanceRecords',
  SERVICE_REMINDERS: 'serviceReminders',
  SERVICE_RECORDS: 'serviceRecords',
  APPOINTMENTS: 'appointments',
} as const; 