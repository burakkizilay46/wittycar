import 'package:dio/dio.dart';
import 'package:wittycar_mobile/core/base/error/dio_exception.dart';
import 'package:wittycar_mobile/core/init/network/dio_manager.dart';
import 'package:wittycar_mobile/features/vehicle_detail/models/service_record_model.dart';

class ServiceRecordService {
  final DioManager _dioManager;

  ServiceRecordService({required DioManager dioManager}) : _dioManager = dioManager;

  Future<List<ServiceRecord>> getServiceRecords(String vehicleId) async {
    try {
      final response = await _dioManager.get('/api/v1/vehicles/$vehicleId/service-records');
      
      final serviceRecordResponse = ServiceRecordResponseModel.fromJson(response.data);
      
      if (serviceRecordResponse.isSuccess && serviceRecordResponse.data != null) {
        return serviceRecordResponse.data!;
      } else {
        throw Exception(serviceRecordResponse.message);
      }
    } catch (e) {
      if (e is DioException) {
        throw CustomDioException.fromDioError(e);
      }
      throw Exception('Failed to load service records: ${e.toString()}');
    }
  }

  Future<ServiceRecord> addServiceRecord(String vehicleId, CreateServiceRecordRequestModel request) async {
    try {
      final response = await _dioManager.post(
        '/api/v1/vehicles/$vehicleId/service-records',
        data: request.toJson(),
      );
      
      final serviceRecordResponse = SingleServiceRecordResponseModel.fromJson(response.data);
      
      if (serviceRecordResponse.isSuccess && serviceRecordResponse.data != null) {
        return serviceRecordResponse.data!;
      } else {
        throw Exception(serviceRecordResponse.message);
      }
    } catch (e) {
      if (e is DioException) {
        throw CustomDioException.fromDioError(e);
      }
      throw Exception('Failed to add service record: ${e.toString()}');
    }
  }
} 