import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenManager {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userDataKey = 'user_data';
  static const String _localIdKey = 'local_id';
  
  // Fallback keys for SharedPreferences when secure storage fails
  static const String _fallbackAccessTokenKey = 'fallback_access_token';
  static const String _fallbackRefreshTokenKey = 'fallback_refresh_token';
  static const String _fallbackUserDataKey = 'fallback_user_data';
  static const String _fallbackLocalIdKey = 'fallback_local_id';

  static TokenManager? _instance;
  static TokenManager get instance => _instance ??= TokenManager._internal();

  TokenManager._internal();

  // Configure secure storage with additional security options
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

  /// Safe wrapper for secure storage operations with fallback to SharedPreferences
  Future<T?> _safeSecureOperation<T>(
    Future<T?> Function() operation,
    String fallbackKey,
    Future<T?> Function(SharedPreferences prefs) fallbackOperation,
  ) async {
    try {
      return await operation();
    } on PlatformException catch (e) {
      print('SecureStorage failed: ${e.message}, using fallback');
      try {
        final prefs = await SharedPreferences.getInstance();
        return await fallbackOperation(prefs);
      } catch (fallbackError) {
        print('Fallback storage also failed: $fallbackError');
        return null;
      }
    } catch (e) {
      print('Unexpected error in secure storage: $e');
      return null;
    }
  }

  /// Safe write operation with fallback
  Future<bool> _safeWrite(String key, String value, String fallbackKey) async {
    try {
      await _secureStorage.write(key: key, value: value);
      return true;
    } on PlatformException catch (e) {
      print('SecureStorage write failed: ${e.message}, using fallback');
      try {
        final prefs = await SharedPreferences.getInstance();
        return await prefs.setString(fallbackKey, value);
      } catch (fallbackError) {
        print('Fallback write failed: $fallbackError');
        return false;
      }
    } catch (e) {
      print('Unexpected error writing to storage: $e');
      return false;
    }
  }

  /// Safe delete operation with fallback
  Future<bool> _safeDelete(String key, String fallbackKey) async {
    try {
      await _secureStorage.delete(key: key);
      // Also clear fallback if it exists
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(fallbackKey);
      return true;
    } on PlatformException catch (e) {
      print('SecureStorage delete failed: ${e.message}, trying fallback cleanup');
      try {
        final prefs = await SharedPreferences.getInstance();
        return await prefs.remove(fallbackKey);
      } catch (fallbackError) {
        print('Fallback delete failed: $fallbackError');
        return false;
      }
    } catch (e) {
      print('Unexpected error deleting from storage: $e');
      return false;
    }
  }

  /// Save access token securely with fallback
  Future<bool> saveAccessToken(String token) async {
    return await _safeWrite(_accessTokenKey, token, _fallbackAccessTokenKey);
  }

  /// Get access token with fallback
  Future<String?> getAccessToken() async {
    return await _safeSecureOperation<String>(
      () => _secureStorage.read(key: _accessTokenKey),
      _fallbackAccessTokenKey,
      (prefs) async => prefs.getString(_fallbackAccessTokenKey),
    );
  }

  /// Save refresh token securely with fallback
  Future<bool> saveRefreshToken(String token) async {
    return await _safeWrite(_refreshTokenKey, token, _fallbackRefreshTokenKey);
  }

  /// Get refresh token with fallback
  Future<String?> getRefreshToken() async {
    return await _safeSecureOperation<String>(
      () => _secureStorage.read(key: _refreshTokenKey),
      _fallbackRefreshTokenKey,
      (prefs) async => prefs.getString(_fallbackRefreshTokenKey),
    );
  }

  /// Save user data as JSON string with fallback
  Future<bool> saveUserData(String userData) async {
    return await _safeWrite(_userDataKey, userData, _fallbackUserDataKey);
  }

  /// Get user data with fallback
  Future<String?> getUserData() async {
    return await _safeSecureOperation<String>(
      () => _secureStorage.read(key: _userDataKey),
      _fallbackUserDataKey,
      (prefs) async => prefs.getString(_fallbackUserDataKey),
    );
  }

  /// Save localId securely with fallback
  Future<bool> saveLocalId(int localId) async {
    return await _safeWrite(_localIdKey, localId.toString(), _fallbackLocalIdKey);
  }

  /// Get localId with fallback
  Future<int?> getLocalId() async {
    final result = await _safeSecureOperation<String>(
      () => _secureStorage.read(key: _localIdKey),
      _fallbackLocalIdKey,
      (prefs) async => prefs.getString(_fallbackLocalIdKey),
    );
    return result != null ? int.tryParse(result) : null;
  }

  /// Generate and save a new localId (timestamp-based unique ID)
  Future<int> generateAndSaveLocalId() async {
    final localId = DateTime.now().millisecondsSinceEpoch;
    await saveLocalId(localId);
    return localId;
  }

  /// Get localId or generate a new one if not exists
  Future<int> getOrGenerateLocalId() async {
    final existingId = await getLocalId();
    if (existingId != null) {
      return existingId;
    }
    return await generateAndSaveLocalId();
  }

  /// Check if user is logged in (has valid access token)
  Future<bool> isLoggedIn() async {
    try {
      final token = await getAccessToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      print('Error checking login status: $e');
      return false;
    }
  }

  /// Clear all stored tokens and user data
  Future<void> clearAll() async {
    try {
      await Future.wait([
        _safeDelete(_accessTokenKey, _fallbackAccessTokenKey),
        _safeDelete(_refreshTokenKey, _fallbackRefreshTokenKey),
        _safeDelete(_userDataKey, _fallbackUserDataKey),
        _safeDelete(_localIdKey, _fallbackLocalIdKey),
      ]);
    } catch (e) {
      print('Error clearing all data: $e');
    }
  }

  /// Clear only tokens (keep user data)
  Future<void> clearTokens() async {
    try {
      await Future.wait([
        _safeDelete(_accessTokenKey, _fallbackAccessTokenKey),
        _safeDelete(_refreshTokenKey, _fallbackRefreshTokenKey),
      ]);
    } catch (e) {
      print('Error clearing tokens: $e');
    }
  }

  /// Check if all secure storage data exists
  Future<bool> hasCompleteAuthData() async {
    try {
      final token = await getAccessToken();
      final userData = await getUserData();
      return token != null && token.isNotEmpty && userData != null && userData.isNotEmpty;
    } catch (e) {
      print('Error checking auth data completeness: $e');
      return false;
    }
  }

  /// Test secure storage functionality
  Future<bool> testSecureStorage() async {
    const testKey = 'test_key';
    const testValue = 'test_value';
    
    try {
      await _secureStorage.write(key: testKey, value: testValue);
      final readValue = await _secureStorage.read(key: testKey);
      await _secureStorage.delete(key: testKey);
      
      return readValue == testValue;
    } on PlatformException catch (e) {
      print('Secure storage test failed: ${e.message}');
      return false;
    } catch (e) {
      print('Unexpected error in secure storage test: $e');
      return false;
    }
  }
} 