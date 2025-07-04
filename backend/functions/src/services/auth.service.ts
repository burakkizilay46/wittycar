import { auth, db, COLLECTIONS } from '../config/firebase.config';
import { CreateUserRequest, LoginRequest, User } from '../types/user.types';
import { generateToken } from '../utils/jwt.utils';
import { Timestamp } from 'firebase-admin/firestore';

export class AuthService {
  /**
   * Register a new user
   */
  async registerUser(userData: CreateUserRequest): Promise<{
    user: User;
    token: string;
  }> {
    try {
      // Create user in Firebase Auth
      const createUserData: any = {
        email: userData.email,
        password: userData.password,
      };

      // Only add displayName if provided
      if (userData.displayName) {
        createUserData.displayName = userData.displayName;
      }

      // Only add phoneNumber if provided
      if (userData.phoneNumber) {
        createUserData.phoneNumber = userData.phoneNumber;
      }

      const userRecord = await auth.createUser(createUserData);
      console.log("🚀 ~ AuthService ~ registerUser ~ userRecord:", userRecord);

      // Create user document in Firestore - use Firestore Timestamp instead of Date
      const now = Timestamp.now();
      
      // Build user document with required fields
      const userDoc: any = {
        uid: userRecord.uid,
        email: userRecord.email!,
        emailVerified: userRecord.emailVerified || false,
        createdAt: now,
        updatedAt: now,
        isActive: true,
      };

      // Add optional fields if they have values
      if (userData.displayName && userData.displayName.trim()) {
        userDoc.displayName = userData.displayName.trim();
      }
      
      // Use phoneNumber from userData first, then from userRecord, or default
      if (userData.phoneNumber && userData.phoneNumber.trim()) {
        userDoc.phoneNumber = userData.phoneNumber.trim();
      } else if (userRecord.phoneNumber) {
        userDoc.phoneNumber = userRecord.phoneNumber;
      } else {
        userDoc.phoneNumber = null; // Explicitly set to null instead of default
      }

      // Filter out undefined values completely
      const filteredUserDoc = Object.fromEntries(
        Object.entries(userDoc).filter(([_, value]) => value !== undefined)
      );

      console.log("🚀 ~ AuthService ~ registerUser ~ About to save to Firestore:", {
        collection: COLLECTIONS.USERS,
        docId: userRecord.uid,
        data: filteredUserDoc,
        fieldCount: Object.keys(filteredUserDoc).length
      });

      // Save user document to Firestore with retry mechanism
      let saveSuccess = false;
      let saveAttempts = 0;
      const maxRetries = 3;
      
      while (!saveSuccess && saveAttempts < maxRetries) {
        saveAttempts++;
        try {
          // Use set with merge: false to ensure we create a new document
          await db.collection(COLLECTIONS.USERS).doc(userRecord.uid).set(filteredUserDoc, { merge: false });
          
          // Verify the document was actually saved by reading it back
          const verifyDoc = await db.collection(COLLECTIONS.USERS).doc(userRecord.uid).get();
          if (verifyDoc.exists && verifyDoc.data()) {
            const savedData = verifyDoc.data();
            console.log("✅ ~ AuthService ~ registerUser ~ User saved and verified in Firestore:", {
              savedFields: Object.keys(savedData || {}),
              attempt: saveAttempts
            });
            saveSuccess = true;
          } else {
            throw new Error('Document verification failed - document not found after save');
          }
        } catch (firestoreError: any) {
          console.error(`❌ ~ AuthService ~ registerUser ~ Firestore save attempt ${saveAttempts} failed:`, {
            error: firestoreError,
            code: firestoreError.code,
            message: firestoreError.message,
            details: firestoreError.details
          });
          
          if (saveAttempts >= maxRetries) {
            // Clean up: delete the user from Firebase Auth since Firestore save failed
            try {
              await auth.deleteUser(userRecord.uid);
              console.log("🧹 ~ AuthService ~ registerUser ~ Cleaned up Auth user due to Firestore failure");
            } catch (cleanupError) {
              console.error("⚠️ ~ AuthService ~ registerUser ~ Failed to cleanup Auth user:", cleanupError);
            }
            
            throw new Error(`Failed to save user to database after ${maxRetries} attempts: ${firestoreError.message}`);
          }
          
          // Wait before retry
          await new Promise(resolve => setTimeout(resolve, 1000 * saveAttempts));
        }
      }

      // Generate JWT token
      const token = generateToken({
        uid: userRecord.uid,
        email: userRecord.email!,
      });

      // Convert Timestamps back to Dates for the response
      const responseUserDoc = {
        ...userDoc,
        createdAt: userDoc.createdAt.toDate(),
        updatedAt: userDoc.updatedAt.toDate(),
      };

      return { user: responseUserDoc, token };
    } catch (error: any) {
      console.error("❌ ~ AuthService ~ registerUser ~ Overall error:", error);
      
      if (error.code === 'auth/email-already-exists') {
        throw new Error('Email already exists');
      }
      
      // If it's already our custom error, re-throw as is
      if (error.message.includes('Failed to save user to database')) {
        throw error;
      }
      
      throw new Error(`Registration failed: ${error.message}`);
    }
  }

  /**
   * Login user with email and password
   */
  async loginUser(loginData: LoginRequest): Promise<{
    user: User;
    token: string;
  }> {
    try {
      // Get user by email from Firebase Auth
      const userRecord = await auth.getUserByEmail(loginData.email);
      
      if (!userRecord) {
        throw new Error('User not found');
      }

      // Get user data from Firestore
      const userDoc = await db
        .collection(COLLECTIONS.USERS)
        .doc(userRecord.uid)
        .get();

      if (!userDoc.exists) {
        throw new Error('User profile not found');
      }

      const userData = userDoc.data() as User;

      if (!userData.isActive) {
        throw new Error('Account is deactivated');
      }

      // Generate JWT token
      const token = generateToken({
        uid: userRecord.uid,
        email: userRecord.email!,
      });

      // Update last login timestamp
      try {
        await db
          .collection(COLLECTIONS.USERS)
          .doc(userRecord.uid)
          .update({
            updatedAt: Timestamp.now(),
          });
        console.log("✅ ~ AuthService ~ loginUser ~ Updated last login timestamp");
      } catch (updateError) {
        console.error("⚠️ ~ AuthService ~ loginUser ~ Failed to update timestamp:", updateError);
        // Don't fail login if timestamp update fails
      }

      // Convert Firestore Timestamps to Dates for response
      const responseUserData = {
        ...userData,
        createdAt: userData.createdAt instanceof Timestamp ? userData.createdAt.toDate() : userData.createdAt,
        updatedAt: userData.updatedAt instanceof Timestamp ? userData.updatedAt.toDate() : userData.updatedAt,
      };

      return { user: responseUserData, token };
    } catch (error: any) {
      console.error("❌ ~ AuthService ~ loginUser ~ Error:", error);
      
      if (error.code === 'auth/user-not-found') {
        throw new Error('Invalid email or password');
      }
      throw new Error(`Login failed: ${error.message}`);
    }
  }

  /**
   * Get user profile by UID
   */
  async getUserProfile(uid: string): Promise<User> {
    try {
      const userDoc = await db
        .collection(COLLECTIONS.USERS)
        .doc(uid)
        .get();

      if (!userDoc.exists) {
        throw new Error('User not found');
      }

      const userData = userDoc.data() as User;
      
      // Convert Firestore Timestamps to Dates for response
      return {
        ...userData,
        createdAt: userData.createdAt instanceof Timestamp ? userData.createdAt.toDate() : userData.createdAt,
        updatedAt: userData.updatedAt instanceof Timestamp ? userData.updatedAt.toDate() : userData.updatedAt,
      };
    } catch (error: any) {
      console.error("❌ ~ AuthService ~ getUserProfile ~ Error:", error);
      throw new Error(`Failed to get user profile: ${error.message}`);
    }
  }

  /**
   * Update user profile
   */
  async updateUserProfile(uid: string, updates: Partial<User>): Promise<User> {
    try {
      const updateData = {
        ...updates,
        updatedAt: Timestamp.now(),
      };

      // Remove fields that shouldn't be updated directly
      delete updateData.uid;
      delete updateData.createdAt;

      console.log("🚀 ~ AuthService ~ updateUserProfile ~ Updating user:", { uid, updateData });

      await db
        .collection(COLLECTIONS.USERS)
        .doc(uid)
        .update(updateData);

      console.log("✅ ~ AuthService ~ updateUserProfile ~ User updated successfully");

      // Return updated user data
      return await this.getUserProfile(uid);
    } catch (error: any) {
      console.error("❌ ~ AuthService ~ updateUserProfile ~ Error:", error);
      throw new Error(`Failed to update user profile: ${error.message}`);
    }
  }

  /**
   * Deactivate user account
   */
  async deactivateUser(uid: string): Promise<void> {
    try {
      // Disable user in Firebase Auth
      await auth.updateUser(uid, { disabled: true });

      // Update user status in Firestore
      await db
        .collection(COLLECTIONS.USERS)
        .doc(uid)
        .update({
          isActive: false,
          updatedAt: Timestamp.now(),
        });
        
      console.log("✅ ~ AuthService ~ deactivateUser ~ User deactivated successfully");
    } catch (error: any) {
      console.error("❌ ~ AuthService ~ deactivateUser ~ Error:", error);
      throw new Error(`Failed to deactivate user: ${error.message}`);
    }
  }

  /**
   * Verify email
   */
  async verifyEmail(uid: string): Promise<void> {
    try {
      await auth.updateUser(uid, { emailVerified: true });
      
      await db
        .collection(COLLECTIONS.USERS)
        .doc(uid)
        .update({
          emailVerified: true,
          updatedAt: Timestamp.now(),
        });
        
      console.log("✅ ~ AuthService ~ verifyEmail ~ Email verified successfully");
    } catch (error: any) {
      console.error("❌ ~ AuthService ~ verifyEmail ~ Error:", error);
      throw new Error(`Failed to verify email: ${error.message}`);
    }
  }
} 