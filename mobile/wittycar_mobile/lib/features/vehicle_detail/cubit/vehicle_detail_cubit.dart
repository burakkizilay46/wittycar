import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wittycar_mobile/core/base/cubit/base_cubit.dart';
import 'package:wittycar_mobile/features/vehicle_detail/models/service_record_model.dart';
import 'package:wittycar_mobile/features/vehicle_detail/services/service_record_service.dart';
import 'package:wittycar_mobile/features/vehicles/models/vehicle_model.dart';

part 'vehicle_detail_state.dart';

class VehicleDetailCubit extends Cubit<VehicleDetailState> with BaseCubit {
  final ServiceRecordService _serviceRecordService;
  VehicleModel? _currentVehicle;

  VehicleDetailCubit({
    required ServiceRecordService serviceRecordService,
  })  : _serviceRecordService = serviceRecordService,
        super(VehicleDetailInitial());

  @override
  void setContext(BuildContext context) {
    this.context = context;
  }

  @override
  void init() {
    // Will be called after vehicle is set
  }

  void setVehicle(VehicleModel vehicle) {
    _currentVehicle = vehicle;
    loadServiceRecords();
  }

  VehicleModel? get currentVehicle => _currentVehicle;

  Future<void> loadServiceRecords() async {
    if (_currentVehicle == null) return;
    
    emit(VehicleDetailLoading());
    
    try {
      final serviceRecords = await _serviceRecordService.getServiceRecords(_currentVehicle!.id);
      emit(VehicleDetailLoaded(serviceRecords: serviceRecords));
    } catch (e) {
      emit(VehicleDetailError(message: e.toString()));
    }
  }

  Future<void> addServiceRecord({
    required String title,
    required String description,
    required DateTime date,
    required int mileage,
  }) async {
    if (_currentVehicle == null) return;
    
    emit(ServiceRecordAdding());
    
    try {
      final request = CreateServiceRecordRequestModel(
        title: title,
        description: description,
        date: date.toIso8601String(),
        mileage: mileage,
      );
      
      final serviceRecord = await _serviceRecordService.addServiceRecord(_currentVehicle!.id, request);
      emit(ServiceRecordAdded(serviceRecord: serviceRecord));
      
      // Reload the service records to get the updated list
      await loadServiceRecords();
    } catch (e) {
      emit(ServiceRecordAddError(message: e.toString()));
    }
  }

  void resetAddState() {
    if (state is ServiceRecordAdded || state is ServiceRecordAddError) {
      if (_currentVehicle != null) {
        loadServiceRecords();
      } else {
        emit(VehicleDetailInitial());
      }
    }
  }
} 