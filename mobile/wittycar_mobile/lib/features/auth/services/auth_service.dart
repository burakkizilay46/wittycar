import 'package:dio/dio.dart';
import 'package:wittycar_mobile/core/base/error/dio_exception.dart';
import 'package:wittycar_mobile/core/init/network/dio_manager.dart';
import 'package:wittycar_mobile/core/init/cache/token_manager.dart';
import 'package:wittycar_mobile/core/utils/phone_utils.dart';
import 'package:wittycar_mobile/features/auth/models/auth_request_model.dart';
import 'package:wittycar_mobile/features/auth/models/auth_response_model.dart';
import 'dart:convert';

class AuthService {
  final DioManager _dioManager;
  final TokenManager _tokenManager = TokenManager.instance;

  AuthService({required DioManager dioManager}) : _dioManager = dioManager;

  Future<AuthResponseModel> login(AuthRequestModel request) async {
    try {
      final response = await _dioManager.post(
        '/api/v1/auth/login',
        data: request.toJson(),
      );
      
      final authResponse = AuthResponseModel.fromJson(response.data);
      
      // Save tokens securely if login is successful
      if (authResponse.isSuccess && authResponse.token != null) {
        final tokenSaved = await _tokenManager.saveAccessToken(authResponse.token!);
        
        if (!tokenSaved) {
          print('⚠️  Warning: Failed to save access token securely');
        }
        
        // Save user data as JSON string for future use
        if (authResponse.user != null) {
          final userDataSaved = await _tokenManager.saveUserData(jsonEncode(authResponse.user!.toJson()));
          
          if (!userDataSaved) {
            print('⚠️  Warning: Failed to save user data securely');
          }
        }
      }
      
      return authResponse;
    } catch (e) {
      if (e is DioException) {
        throw CustomDioException.fromDioError(e);
      }
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  Future<AuthResponseModel> register(AuthRequestModel request) async {
    try {
      // Validate phone number using E.164 standard
      if (request.phoneNumber == null || request.phoneNumber!.trim().isEmpty) {
        throw Exception('Phone number is required for registration');
      }
      
      // Use PhoneUtils for E.164 validation
      PhoneUtils.validateE164(request.phoneNumber!.trim());
      
      final response = await _dioManager.post(
        '/api/v1/auth/register',
        data: request.toJson(),
      );
      
      final authResponse = AuthResponseModel.fromJson(response.data);
      
      // Save tokens securely if registration is successful
      if (authResponse.isSuccess && authResponse.token != null) {
        final tokenSaved = await _tokenManager.saveAccessToken(authResponse.token!);
        
        if (!tokenSaved) {
          print('⚠️  Warning: Failed to save access token securely');
        }
        
        // Save user data as JSON string for future use
        if (authResponse.user != null) {
          final userDataSaved = await _tokenManager.saveUserData(jsonEncode(authResponse.user!.toJson()));
          
          if (!userDataSaved) {
            print('⚠️  Warning: Failed to save user data securely');
          }
        }
      }
      
      return authResponse;
    } catch (e) {
      if (e is DioException) {
        throw CustomDioException.fromDioError(e);
      }
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  Future<UserModel?> getProfile() async {
    try {
      final response = await _dioManager.get('/api/v1/auth/profile');
      
      if (response.data['success'] == true) {
        return UserModel.fromJson(response.data['data']);
      }
      return null;
    } catch (e) {
      if (e is DioException) {
        throw CustomDioException.fromDioError(e);
      }
      throw Exception('Failed to get profile: ${e.toString()}');
    }
  }

  Future<bool> updateProfile(Map<String, dynamic> profileData) async {
    try {
      final response = await _dioManager.put(
        '/api/v1/auth/profile',
        data: profileData,
      );
      
      return response.data['success'] == true;
    } catch (e) {
      if (e is DioException) {
        throw CustomDioException.fromDioError(e);
      }
      throw Exception('Failed to update profile: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    try {
      // Clear local tokens (backend doesn't have logout endpoint based on the routes)
      await _tokenManager.clearAll();
    } catch (e) {
      // Even if clearing fails, we should continue with logout
      print('Error during logout: $e');
    }
  }

  Future<bool> isLoggedIn() async {
    return await _tokenManager.isLoggedIn();
  }

  Future<UserModel?> getCachedUser() async {
    try {
      final userData = await _tokenManager.getUserData();
      if (userData != null && userData.isNotEmpty) {
        final userJson = jsonDecode(userData);
        return UserModel.fromJson(userJson);
      }
      return null;
    } catch (e) {
      print('Error getting cached user: $e');
      return null;
    }
  }
} 