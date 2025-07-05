part of 'appointment_cubit.dart';

abstract class AppointmentState extends Equatable {
  const AppointmentState();
  
  @override
  List<Object?> get props => [];
}

class AppointmentInitial extends AppointmentState {}

class AppointmentLoading extends AppointmentState {}

class AppointmentLoaded extends AppointmentState {
  final List<Appointment> appointments;
  
  const AppointmentLoaded({required this.appointments});
  
  @override
  List<Object> get props => [appointments];
}

class AppointmentError extends AppointmentState {
  final String message;
  
  const AppointmentError({required this.message});
  
  @override
  List<Object> get props => [message];
}

class AppointmentCreating extends AppointmentState {}

class AppointmentCreated extends AppointmentState {
  final Appointment appointment;
  
  const AppointmentCreated({required this.appointment});
  
  @override
  List<Object> get props => [appointment];
}

class AppointmentCreateError extends AppointmentState {
  final String message;
  
  const AppointmentCreateError({required this.message});
  
  @override
  List<Object> get props => [message];
}

class AppointmentUpdating extends AppointmentState {}

class AppointmentUpdated extends AppointmentState {
  final Appointment appointment;
  
  const AppointmentUpdated({required this.appointment});
  
  @override
  List<Object> get props => [appointment];
}

class AppointmentUpdateError extends AppointmentState {
  final String message;
  
  const AppointmentUpdateError({required this.message});
  
  @override
  List<Object> get props => [message];
}

class AppointmentDeleting extends AppointmentState {}

class AppointmentDeleted extends AppointmentState {}

class AppointmentDeleteError extends AppointmentState {
  final String message;
  
  const AppointmentDeleteError({required this.message});
  
  @override
  List<Object> get props => [message];
} 