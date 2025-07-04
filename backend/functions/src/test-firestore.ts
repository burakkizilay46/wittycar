import { db, auth, COLLECTIONS, isFirebaseInitialized } from './config/firebase.config';
import { Timestamp } from 'firebase-admin/firestore';

async function testFirestoreConnection() {
  console.log('🔍 Testing Firestore connection...');
  
  try {
    // 1. Check if Firebase is initialized
    console.log('1. Firebase initialized:', isFirebaseInitialized());
    
    // 2. Test basic Firestore connection
    console.log('2. Testing Firestore connection...');
    const testDoc = await db.collection('test').doc('connection').get();
    console.log('✅ Firestore connection works');
    
    // 3. Test writing to a test collection
    console.log('3. Testing write operation to test collection...');
    const testData = {
      message: 'Hello Firestore',
      timestamp: Timestamp.now(),
      testId: 'test-123'
    };
    
    await db.collection('test').doc('write-test').set(testData);
    console.log('✅ Write to test collection successful');
    
    // 4. Test reading from test collection
    const writtenDoc = await db.collection('test').doc('write-test').get();
    if (writtenDoc.exists) {
      console.log('✅ Read from test collection successful:', writtenDoc.data());
    } else {
      console.log('❌ Document was not found after write');
    }
    
    // 5. Test writing to users collection specifically
    console.log('4. Testing write operation to users collection...');
    const userTestData = {
      uid: 'test-user-123',
      email: 'test@example.com',
      phoneNumber: '+11234567890',
      emailVerified: false,
      createdAt: Timestamp.now(),
      updatedAt: Timestamp.now(),
      isActive: true,
      displayName: 'Test User'
    };
    
    await db.collection(COLLECTIONS.USERS).doc('test-user-123').set(userTestData);
    console.log('✅ Write to users collection successful');
    
    // 6. Test reading from users collection
    const userDoc = await db.collection(COLLECTIONS.USERS).doc('test-user-123').get();
    if (userDoc.exists) {
      console.log('✅ Read from users collection successful:', userDoc.data());
    } else {
      console.log('❌ User document was not found after write');
    }
    
    // 7. Clean up test data
    console.log('5. Cleaning up test data...');
    await db.collection('test').doc('connection').delete();
    await db.collection('test').doc('write-test').delete();
    await db.collection(COLLECTIONS.USERS).doc('test-user-123').delete();
    console.log('✅ Cleanup successful');
    
    console.log('\n🎉 All Firestore tests passed!');
    
  } catch (error: any) {
    console.error('❌ Firestore test failed:', {
      error: error,
      code: error.code,
      message: error.message,
      details: error.details,
      stack: error.stack
    });
  }
}

async function testAuthAndFirestore() {
  console.log('\n🔍 Testing Auth + Firestore flow...');
  
  try {
    // Create a test user in Auth
    const testUserData = {
      email: 'firestoretest@example.com',
      password: 'test123456',
      displayName: 'Firestore Test User'
    };
    
    console.log('1. Creating test user in Firebase Auth...');
    const userRecord = await auth.createUser(testUserData);
    console.log('✅ Auth user created:', userRecord.uid);
    
    // Try to save to Firestore
    console.log('2. Saving user to Firestore...');
    const firestoreData = {
      uid: userRecord.uid,
      email: userRecord.email!,
      phoneNumber: '+11234567890',
      emailVerified: false,
      createdAt: Timestamp.now(),
      updatedAt: Timestamp.now(),
      isActive: true,
      displayName: userRecord.displayName || 'Test User'
    };
    
    await db.collection(COLLECTIONS.USERS).doc(userRecord.uid).set(firestoreData);
    console.log('✅ User saved to Firestore successfully');
    
    // Verify the data was saved
    console.log('3. Verifying data was saved...');
    const savedDoc = await db.collection(COLLECTIONS.USERS).doc(userRecord.uid).get();
    if (savedDoc.exists) {
      console.log('✅ Data verification successful:', savedDoc.data());
    } else {
      console.log('❌ Data not found in Firestore');
    }
    
    // Clean up
    console.log('4. Cleaning up test user...');
    await auth.deleteUser(userRecord.uid);
    await db.collection(COLLECTIONS.USERS).doc(userRecord.uid).delete();
    console.log('✅ Test user cleanup successful');
    
    console.log('\n🎉 Auth + Firestore test passed!');
    
  } catch (error: any) {
    console.error('❌ Auth + Firestore test failed:', {
      error: error,
      code: error.code,
      message: error.message,
      details: error.details,
      stack: error.stack
    });
  }
}

// Run both tests
async function runAllTests() {
  console.log('🚀 Starting Firestore debug tests...\n');
  
  await testFirestoreConnection();
  await testAuthAndFirestore();
  
  console.log('\n✨ All tests completed!');
  process.exit(0);
}

// Only run if this file is executed directly
if (require.main === module) {
  runAllTests().catch(console.error);
}

export { testFirestoreConnection, testAuthAndFirestore }; 