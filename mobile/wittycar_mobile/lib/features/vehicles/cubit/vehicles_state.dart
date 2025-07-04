part of 'vehicles_cubit.dart';

abstract class VehiclesState extends Equatable {
  const VehiclesState();
  
  @override
  List<Object?> get props => [];
}

class VehiclesInitial extends VehiclesState {}

class VehiclesLoading extends VehiclesState {}

class VehiclesLoaded extends VehiclesState {
  final List<VehicleModel> vehicles;
  
  const VehiclesLoaded({required this.vehicles});
  
  @override
  List<Object> get props => [vehicles];
}

class VehiclesError extends VehiclesState {
  final String message;
  
  const VehiclesError({required this.message});
  
  @override
  List<Object> get props => [message];
}

class VehicleAdding extends VehiclesState {}

class VehicleAdded extends VehiclesState {
  final VehicleModel vehicle;
  
  const VehicleAdded({required this.vehicle});
  
  @override
  List<Object> get props => [vehicle];
}

class VehicleAddError extends VehiclesState {
  final String message;
  
  const VehicleAddError({required this.message});
  
  @override
  List<Object> get props => [message];
} 