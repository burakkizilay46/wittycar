part of 'vehicle_detail_cubit.dart';

abstract class VehicleDetailState extends Equatable {
  const VehicleDetailState();
  
  @override
  List<Object?> get props => [];
}

class VehicleDetailInitial extends VehicleDetailState {}

class VehicleDetailLoading extends VehicleDetailState {}

class VehicleDetailLoaded extends VehicleDetailState {
  final List<ServiceRecord> serviceRecords;
  
  const VehicleDetailLoaded({required this.serviceRecords});
  
  @override
  List<Object> get props => [serviceRecords];
}

class VehicleDetailError extends VehicleDetailState {
  final String message;
  
  const VehicleDetailError({required this.message});
  
  @override
  List<Object> get props => [message];
}

class ServiceRecordAdding extends VehicleDetailState {}

class ServiceRecordAdded extends VehicleDetailState {
  final ServiceRecord serviceRecord;
  
  const ServiceRecordAdded({required this.serviceRecord});
  
  @override
  List<Object> get props => [serviceRecord];
}

class ServiceRecordAddError extends VehicleDetailState {
  final String message;
  
  const ServiceRecordAddError({required this.message});
  
  @override
  List<Object> get props => [message];
} 