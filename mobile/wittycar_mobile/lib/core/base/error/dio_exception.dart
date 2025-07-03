import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:wittycar_mobile/core/base/error/error_response.dart';

class CustomDioException implements Exception {
  ErrorResponse? _errorResponse;
  CustomDioException.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.cancel:
        message = 'Request to API server was cancelled';
        break;
      case DioExceptionType.connectionTimeout:
        message =
            'Connection timeout with server. Please check your internet-connection.';
        break;
      case DioExceptionType.unknown:
        message = 'Connection to API server failed due to internet connection';
        break;
      case DioExceptionType.receiveTimeout:
        message = 'Receive timeout in connection with API server';
        break;
      case DioExceptionType.badResponse:
        final Map<String, dynamic> errorRes =
            jsonDecode('${dioError.response}') as Map<String, dynamic>;
        _errorResponse = ErrorResponse.fromJson(errorRes);
        message = _handleError(_errorResponse?.status ?? 400);
        break;
      case DioExceptionType.sendTimeout:
        message = 'Send timeout in connection with API server';
        break;
      default:
        message = 'Something went wrong';
        break;
    }
  }

  late String message;

  String _handleError(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request';
      case 404:
        return 'The requested resource was not found';
      case 500:
        return 'There was a problem with the connection';
      default:
        return 'Something went wrong';
    }
  }

  @override
  String toString() => message;
}
