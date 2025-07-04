import 'package:dio/dio.dart';
import 'package:wittycar_mobile/core/base/error/dio_exception.dart';
import 'package:wittycar_mobile/core/init/network/dio_manager.dart';
import 'package:wittycar_mobile/features/vehicles/models/vehicle_model.dart';

class VehicleService {
  final DioManager _dioManager;

  VehicleService({required DioManager dioManager}) : _dioManager = dioManager;

  Future<List<VehicleModel>> getVehicles() async {
    try {
      final response = await _dioManager.get('/api/v1/vehicles');
      
      final vehicleResponse = VehicleResponseModel.fromJson(response.data);
      
      if (vehicleResponse.isSuccess && vehicleResponse.data != null) {
        return vehicleResponse.data!;
      } else {
        throw Exception(vehicleResponse.message);
      }
    } catch (e) {
      if (e is DioException) {
        throw CustomDioException.fromDioError(e);
      }
      throw Exception('Failed to load vehicles: ${e.toString()}');
    }
  }

  Future<VehicleModel> addVehicle(CreateVehicleRequestModel request) async {
    try {
      final response = await _dioManager.post(
        '/api/v1/vehicles',
        data: request.toJson(),
      );
      
      final vehicleResponse = SingleVehicleResponseModel.fromJson(response.data);
      
      if (vehicleResponse.isSuccess && vehicleResponse.data != null) {
        return vehicleResponse.data!;
      } else {
        throw Exception(vehicleResponse.message);
      }
    } catch (e) {
      if (e is DioException) {
        throw CustomDioException.fromDioError(e);
      }
      throw Exception('Failed to add vehicle: ${e.toString()}');
    }
  }

  Future<VehicleModel> updateVehicle(String vehicleId, UpdateVehicleRequestModel request) async {
    try {
      final response = await _dioManager.put(
        '/api/v1/vehicles/$vehicleId',
        data: request.toJson(),
      );
      
      final vehicleResponse = SingleVehicleResponseModel.fromJson(response.data);
      
      if (vehicleResponse.isSuccess && vehicleResponse.data != null) {
        return vehicleResponse.data!;
      } else {
        throw Exception(vehicleResponse.message);
      }
    } catch (e) {
      if (e is DioException) {
        throw CustomDioException.fromDioError(e);
      }
      throw Exception('Failed to update vehicle: ${e.toString()}');
    }
  }

  Future<bool> deleteVehicle(String vehicleId) async {
    try {
      final response = await _dioManager.delete('/api/v1/vehicles/$vehicleId');
      
      final responseData = response.data;
      
      if (responseData['success'] == true) {
        return true;
      } else {
        throw Exception(responseData['message'] ?? 'Failed to delete vehicle');
      }
    } catch (e) {
      if (e is DioException) {
        throw CustomDioException.fromDioError(e);
      }
      throw Exception('Failed to delete vehicle: ${e.toString()}');
    }
  }
} 