// ignore_for_file: non_constant_identifier_names

import 'package:wittycar_mobile/core/constants/app/app_constants.dart';
import 'package:wittycar_mobile/core/init/network/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:wittycar_mobile/core/init/cache/token_manager.dart';
import './dio_config.dart';

class DioManager {
  final String baseUrl;
  late Dio _dio;
  final TokenManager _tokenManager = TokenManager.instance;

  DioManager({required this.baseUrl}) {
    _dio = Dio()
      ..options.baseUrl = baseUrl
      ..options.connectTimeout = const Duration(milliseconds: HttpConfig.connectionTimeout)
      ..options.receiveTimeout = const Duration(milliseconds: HttpConfig.receiveTimeout)
      ..options.headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

    // Add interceptors
    _dio.interceptors.add(_createAuthInterceptor());
    _dio.interceptors.add(_createLogInterceptor());
    _dio.interceptors.add(_createErrorInterceptor());
  }

  /// Create auth interceptor for automatic JWT token injection
  InterceptorsWrapper _createAuthInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        try {
          // Add Authorization header for protected routes
          final token = await _tokenManager.getAccessToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
            print('🔐 Added auth token to request: ${options.path}');
          } else {
            print('⚠️  No token available for request: ${options.path}');
          }
        } catch (e) {
          print('❌ Error getting access token: $e');
          // Continue without token - let the backend handle unauthorized requests
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        // Handle 401 errors (token expired)
        if (error.response?.statusCode == 401) {
          print('🔄 Token expired, attempting refresh...');
          try {
            // Try to refresh token
            final refreshed = await _refreshToken();
            if (refreshed) {
              print('✅ Token refreshed successfully, retrying request...');
              // Retry the original request with new token
              final token = await _tokenManager.getAccessToken();
              if (token != null && token.isNotEmpty) {
                error.requestOptions.headers['Authorization'] = 'Bearer $token';
                
                try {
                  final response = await _dio.fetch(error.requestOptions);
                  handler.resolve(response);
                  return;
                } catch (e) {
                  print('❌ Retry after token refresh failed: $e');
                  // If retry fails, proceed with original error
                }
              }
            } else {
              print('❌ Token refresh failed');
            }
          } catch (e) {
            print('❌ Error during token refresh: $e');
          }
        }
        handler.next(error);
      },
    );
  }

  /// Create logging interceptor
  InterceptorsWrapper _createLogInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        print('🚀 REQUEST[${options.method}] => PATH: ${options.path}');
        print('📝 Headers: ${options.headers}');
        if (options.data != null) {
          print('📦 Data: ${options.data}');
        }
        handler.next(options);
      },
      onResponse: (response, handler) {
        print('✅ RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
        print('📦 Data: ${response.data}');
        handler.next(response);
      },
      onError: (error, handler) {
        print('❌ ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path}');
        print('📦 Error: ${error.response?.data}');
        handler.next(error);
      },
    );
  }

  /// Create error handling interceptor
  InterceptorsWrapper _createErrorInterceptor() {
    return InterceptorsWrapper(
      onError: (error, handler) {
        // Transform backend error response to user-friendly format
        if (error.response?.data != null) {
          final data = error.response!.data;
          if (data is Map<String, dynamic>) {
            // Backend returns: { success: false, message: "error message" }
            if (data.containsKey('message')) {
              error = DioException(
                requestOptions: error.requestOptions,
                response: error.response,
                message: data['message'],
                type: error.type,
              );
            }
          }
        }
        handler.next(error);
      },
    );
  }

  /// Attempt to refresh the access token
  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _tokenManager.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        return false;
      }

      // Create a new Dio instance without interceptors to avoid infinite loop
      final refreshDio = Dio()
        ..options.baseUrl = baseUrl
        ..options.connectTimeout = const Duration(milliseconds: HttpConfig.connectionTimeout)
        ..options.receiveTimeout = const Duration(milliseconds: HttpConfig.receiveTimeout);

      final response = await refreshDio.post(
        '/api/v1/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final newToken = response.data['data']['token'];
        final newRefreshToken = response.data['data']['refreshToken'];
        
        await _tokenManager.saveAccessToken(newToken);
        if (newRefreshToken != null) {
          await _tokenManager.saveRefreshToken(newRefreshToken);
        }
        
        return true;
      }
      
      return false;
    } catch (e) {
      print('Token refresh failed: $e');
      // Clear tokens if refresh fails
      await _tokenManager.clearTokens();
      return false;
    }
  }

  // HTTP Methods
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    return await _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return await _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return await _dio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return await _dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// Clear all cached data and reset dio instance
  void clearCache() {
    _dio.interceptors.clear();
  }
}
