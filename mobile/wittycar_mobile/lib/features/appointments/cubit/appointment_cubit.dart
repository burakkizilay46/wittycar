import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wittycar_mobile/core/base/cubit/base_cubit.dart';
import 'package:wittycar_mobile/features/appointments/models/appointment_model.dart';
import 'package:wittycar_mobile/features/appointments/services/appointment_service.dart';

part 'appointment_state.dart';

class AppointmentCubit extends Cubit<AppointmentState> with BaseCubit {
  final AppointmentService _appointmentService;

  AppointmentCubit({
    required AppointmentService appointmentService,
  })  : _appointmentService = appointmentService,
        super(AppointmentInitial());

  @override
  void setContext(BuildContext context) {
    this.context = context;
  }

  @override
  void init() {
    loadAppointments();
  }

  Future<void> loadAppointments() async {
    emit(AppointmentLoading());
    
    try {
      final appointments = await _appointmentService.getAppointments();
      emit(AppointmentLoaded(appointments: appointments));
    } catch (e) {
      emit(AppointmentError(message: e.toString()));
    }
  }

  Future<void> createAppointment({
    required String vehicleId,
    required DateTime dateTime,
  }) async {
    emit(AppointmentCreating());
    
    try {
      final request = CreateAppointmentRequestModel.fromDateTime(
        vehicleId: vehicleId,
        dateTime: dateTime,
      );
      
      final appointment = await _appointmentService.createAppointment(request);
      emit(AppointmentCreated(appointment: appointment));
      
      // Reload appointments to get the updated list
      await loadAppointments();
    } catch (e) {
      emit(AppointmentCreateError(message: e.toString()));
    }
  }

  Future<void> updateAppointment({
    required String appointmentId,
    String? vehicleId,
    DateTime? dateTime,
  }) async {
    emit(AppointmentUpdating());
    
    try {
      final updateData = <String, dynamic>{};
      if (vehicleId != null) updateData['vehicleId'] = vehicleId;
      if (dateTime != null) updateData['date'] = dateTime.toIso8601String();
      
      final appointment = await _appointmentService.updateAppointment(appointmentId, updateData);
      emit(AppointmentUpdated(appointment: appointment));
      
      // Reload appointments to get the updated list
      await loadAppointments();
    } catch (e) {
      emit(AppointmentUpdateError(message: e.toString()));
    }
  }

  Future<void> deleteAppointment(String appointmentId) async {
    emit(AppointmentDeleting());
    
    try {
      final success = await _appointmentService.deleteAppointment(appointmentId);
      if (success) {
        emit(AppointmentDeleted());
        // Reload appointments to get the updated list
        await loadAppointments();
      } else {
        emit(AppointmentDeleteError(message: 'Failed to delete appointment'));
      }
    } catch (e) {
      emit(AppointmentDeleteError(message: e.toString()));
    }
  }

  void resetState() {
    if (state is AppointmentCreated || 
        state is AppointmentCreateError ||
        state is AppointmentUpdated ||
        state is AppointmentUpdateError ||
        state is AppointmentDeleted ||
        state is AppointmentDeleteError) {
      loadAppointments();
    }
  }
} 