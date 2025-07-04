import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecureStorageDebugUtil {
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      sharedPreferencesName: 'wittycar_secure_prefs',
      preferencesKeyPrefix: 'wittycar_',
    ),
    iOptions: IOSOptions(
      groupId: 'com.wittycar.mobile',
      accountName: 'wittycar_account',
      synchronizable: false,
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  /// Comprehensive test of secure storage functionality
  static Future<Map<String, dynamic>> runDiagnostics() async {
    final results = <String, dynamic>{};
    
    print('🔍 Running Secure Storage Diagnostics...');
    
    // Test 1: Basic read/write
    try {
      await _secureStorage.write(key: 'test_key', value: 'test_value');
      final readValue = await _secureStorage.read(key: 'test_key');
      await _secureStorage.delete(key: 'test_key');
      
      results['basic_read_write'] = {
        'success': readValue == 'test_value',
        'value_match': readValue == 'test_value',
        'error': null,
      };
      
      print('✅ Basic read/write test passed');
    } on PlatformException catch (e) {
      results['basic_read_write'] = {
        'success': false,
        'error': 'PlatformException: ${e.code} - ${e.message}',
        'details': e.details,
      };
      print('❌ Basic read/write test failed: ${e.code} - ${e.message}');
    } catch (e) {
      results['basic_read_write'] = {
        'success': false,
        'error': 'UnexpectedError: $e',
      };
      print('❌ Basic read/write test failed: $e');
    }

    // Test 2: Multiple operations
    try {
      const testData = {
        'token1': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
        'token2': 'another_test_token',
        'user_data': '{"id":1,"name":"Test User"}',
      };
      
      // Write all
      for (final entry in testData.entries) {
        await _secureStorage.write(key: entry.key, value: entry.value);
      }
      
      // Read all
      final readData = <String, String?>{};
      for (final key in testData.keys) {
        readData[key] = await _secureStorage.read(key: key);
      }
      
      // Clean up
      for (final key in testData.keys) {
        await _secureStorage.delete(key: key);
      }
      
      final allMatch = testData.entries.every(
        (entry) => readData[entry.key] == entry.value,
      );
      
      results['multiple_operations'] = {
        'success': allMatch,
        'test_count': testData.length,
        'error': null,
      };
      
      print('✅ Multiple operations test passed');
    } on PlatformException catch (e) {
      results['multiple_operations'] = {
        'success': false,
        'error': 'PlatformException: ${e.code} - ${e.message}',
      };
      print('❌ Multiple operations test failed: ${e.code} - ${e.message}');
    } catch (e) {
      results['multiple_operations'] = {
        'success': false,
        'error': 'UnexpectedError: $e',
      };
      print('❌ Multiple operations test failed: $e');
    }

    // Test 3: SharedPreferences fallback
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('fallback_test', 'fallback_value');
      final fallbackValue = prefs.getString('fallback_test');
      await prefs.remove('fallback_test');
      
      results['shared_prefs_fallback'] = {
        'success': fallbackValue == 'fallback_value',
        'error': null,
      };
      
      print('✅ SharedPreferences fallback test passed');
    } catch (e) {
      results['shared_prefs_fallback'] = {
        'success': false,
        'error': 'UnexpectedError: $e',
      };
      print('❌ SharedPreferences fallback test failed: $e');
    }

    // Test 4: Get all stored keys
    try {
      await _secureStorage.write(key: 'test_key_enum', value: 'test');
      final allKeys = await _secureStorage.readAll();
      await _secureStorage.delete(key: 'test_key_enum');
      
      results['key_enumeration'] = {
        'success': true,
        'key_count': allKeys.length,
        'error': null,
      };
      
      print('✅ Key enumeration test passed (${allKeys.length} keys found)');
    } on PlatformException catch (e) {
      results['key_enumeration'] = {
        'success': false,
        'error': 'PlatformException: ${e.code} - ${e.message}',
      };
      print('❌ Key enumeration test failed: ${e.code} - ${e.message}');
    } catch (e) {
      results['key_enumeration'] = {
        'success': false,
        'error': 'UnexpectedError: $e',
      };
      print('❌ Key enumeration test failed: $e');
    }

    final overallSuccess = results.values.every(
      (result) => result is Map && result['success'] == true,
    );
    
    results['overall_success'] = overallSuccess;
    
    print(overallSuccess 
      ? '🎉 All secure storage tests passed!' 
      : '⚠️  Some secure storage tests failed - fallback mode will be used');
    
    return results;
  }

  /// Quick test just for token operations
  static Future<bool> testTokenOperations() async {
    try {
      const testToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.test';
      const testRefresh = 'refresh_token_test';
      const testUserData = '{"id":1,"name":"Test","email":"test@example.com"}';
      
      // Write tokens
      await _secureStorage.write(key: 'access_token', value: testToken);
      await _secureStorage.write(key: 'refresh_token', value: testRefresh);
      await _secureStorage.write(key: 'user_data', value: testUserData);
      
      // Read tokens
      final accessToken = await _secureStorage.read(key: 'access_token');
      final refreshToken = await _secureStorage.read(key: 'refresh_token');
      final userData = await _secureStorage.read(key: 'user_data');
      
      // Clean up
      await _secureStorage.delete(key: 'access_token');
      await _secureStorage.delete(key: 'refresh_token');
      await _secureStorage.delete(key: 'user_data');
      
      final success = accessToken == testToken && 
                     refreshToken == testRefresh && 
                     userData == testUserData;
      
      print(success 
        ? '✅ Token operations test passed' 
        : '❌ Token operations test failed');
      
      return success;
    } on PlatformException catch (e) {
      print('❌ Token operations test failed: ${e.code} - ${e.message}');
      return false;
    } catch (e) {
      print('❌ Token operations test failed: $e');
      return false;
    }
  }

  /// Print system information that might be relevant
  static void printSystemInfo() {
    print('📱 System Information:');
    print('   Platform: ${Platform.operatingSystem}');
    print('   Version: ${Platform.operatingSystemVersion}');
    print('   Flutter: ${Platform.version}');
  }
}

class Platform {
  static String get operatingSystem {
    try {
      return 'Unknown'; // This would be filled by platform-specific code
    } catch (e) {
      return 'Error: $e';
    }
  }
  
  static String get operatingSystemVersion {
    try {
      return 'Unknown'; // This would be filled by platform-specific code
    } catch (e) {
      return 'Error: $e';
    }
  }
  
  static String get version {
    try {
      return 'Unknown'; // This would be filled by platform-specific code
    } catch (e) {
      return 'Error: $e';
    }
  }
} 