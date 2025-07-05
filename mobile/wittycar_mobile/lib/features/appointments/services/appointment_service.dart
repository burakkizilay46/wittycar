import 'package:dio/dio.dart';
import 'package:wittycar_mobile/core/base/error/dio_exception.dart';
import 'package:wittycar_mobile/core/init/network/dio_manager.dart';
import 'package:wittycar_mobile/features/appointments/models/appointment_model.dart';

class AppointmentService {
  final DioManager _dioManager;

  AppointmentService({required DioManager dioManager}) : _dioManager = dioManager;

  Future<List<Appointment>> getAppointments() async {
    try {
      final response = await _dioManager.get('/api/v1/appointments');
      
      final appointmentResponse = AppointmentResponseModel.fromJson(response.data);
      
      if (appointmentResponse.isSuccess && appointmentResponse.data != null) {
        return appointmentResponse.data!;
      } else {
        throw Exception(appointmentResponse.message);
      }
    } catch (e) {
      if (e is DioException) {
        throw CustomDioException.fromDioError(e);
      }
      throw Exception('Failed to load appointments: ${e.toString()}');
    }
  }

  Future<Appointment> createAppointment(CreateAppointmentRequestModel request) async {
    try {
      final response = await _dioManager.post(
        '/api/v1/appointments',
        data: request.toJson(),
      );
      
      final appointmentResponse = SingleAppointmentResponseModel.fromJson(response.data);
      
      if (appointmentResponse.isSuccess && appointmentResponse.data != null) {
        return appointmentResponse.data!;
      } else {
        throw Exception(appointmentResponse.message);
      }
    } catch (e) {
      if (e is DioException) {
        throw CustomDioException.fromDioError(e);
      }
      throw Exception('Failed to create appointment: ${e.toString()}');
    }
  }

  Future<Appointment> getAppointmentById(String appointmentId) async {
    try {
      final response = await _dioManager.get('/api/v1/appointments/$appointmentId');
      
      final appointmentResponse = SingleAppointmentResponseModel.fromJson(response.data);
      
      if (appointmentResponse.isSuccess && appointmentResponse.data != null) {
        return appointmentResponse.data!;
      } else {
        throw Exception(appointmentResponse.message);
      }
    } catch (e) {
      if (e is DioException) {
        throw CustomDioException.fromDioError(e);
      }
      throw Exception('Failed to load appointment: ${e.toString()}');
    }
  }

  Future<Appointment> updateAppointment(String appointmentId, Map<String, dynamic> updateData) async {
    try {
      final response = await _dioManager.put(
        '/api/v1/appointments/$appointmentId',
        data: updateData,
      );
      
      final appointmentResponse = SingleAppointmentResponseModel.fromJson(response.data);
      
      if (appointmentResponse.isSuccess && appointmentResponse.data != null) {
        return appointmentResponse.data!;
      } else {
        throw Exception(appointmentResponse.message);
      }
    } catch (e) {
      if (e is DioException) {
        throw CustomDioException.fromDioError(e);
      }
      throw Exception('Failed to update appointment: ${e.toString()}');
    }
  }

  Future<bool> deleteAppointment(String appointmentId) async {
    try {
      final response = await _dioManager.delete('/api/v1/appointments/$appointmentId');
      
      final responseData = response.data;
      
      if (responseData['success'] == true) {
        return true;
      } else {
        throw Exception(responseData['message'] ?? 'Failed to delete appointment');
      }
    } catch (e) {
      if (e is DioException) {
        throw CustomDioException.fromDioError(e);
      }
      throw Exception('Failed to delete appointment: ${e.toString()}');
    }
  }
} 