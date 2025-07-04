import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wittycar_mobile/core/base/cubit/base_cubit.dart';
import 'package:wittycar_mobile/core/constants/navigation/navigation_constants.dart';
import 'package:wittycar_mobile/features/vehicles/models/vehicle_model.dart';
import 'package:wittycar_mobile/features/vehicles/services/vehicle_service.dart';

part 'vehicles_state.dart';

class VehiclesCubit extends Cubit<VehiclesState> with BaseCubit {
  final VehicleService _vehicleService;

  VehiclesCubit({
    required VehicleService vehicleService,
  })  : _vehicleService = vehicleService,
        super(VehiclesInitial());

  @override
  void setContext(BuildContext context) {
    this.context = context;
  }

  @override
  void init() {
    loadVehicles();
  }

  Future<void> loadVehicles() async {
    emit(VehiclesLoading());
    
    try {
      final vehicles = await _vehicleService.getVehicles();
      emit(VehiclesLoaded(vehicles: vehicles));
    } catch (e) {
      emit(VehiclesError(message: e.toString()));
    }
  }

  Future<void> addVehicle({
    required String brand,
    required String model,
    required int year,
    required String plate,
    required int mileage,
  }) async {
    emit(VehicleAdding());
    
    try {
      final request = CreateVehicleRequestModel(
        brand: brand,
        model: model,
        year: year,
        plate: plate,
        mileage: mileage,
      );
      
      final vehicle = await _vehicleService.addVehicle(request);
      emit(VehicleAdded(vehicle: vehicle));
      
      // Show success message
      if (context != null) {
        ScaffoldMessenger.of(context!).showSnackBar(
          SnackBar(
            content: Text('Araç başarıyla eklendi!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      }
      
      // Navigate back to vehicles list and refresh
      navigation.navigateToPageClear(path: NavigationConstants.VEHICLES_LIST);
      
      // Reload vehicles to get updated list
      loadVehicles();
    } catch (e) {
      emit(VehicleAddError(message: e.toString()));
    }
  }

  void resetState() {
    emit(VehiclesInitial());
  }

  void resetAddState() {
    // If we're in adding/add error state, go back to loaded state
    if (state is VehicleAdding || state is VehicleAddError || state is VehicleAdded) {
      loadVehicles();
    }
  }
} 