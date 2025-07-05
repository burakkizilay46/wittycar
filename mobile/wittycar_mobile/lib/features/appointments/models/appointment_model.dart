import 'package:json_annotation/json_annotation.dart';
import 'package:wittycar_mobile/core/base/model/base_model.dart';

part 'appointment_model.g.dart';

// Appointments API response wrapper
@JsonSerializable()
class AppointmentResponseModel extends BaseModel<AppointmentResponseModel> {
  final bool success;
  final String message;
  final List<Appointment>? data;
  final DateTime timestamp;

  AppointmentResponseModel({
    required this.success,
    required this.message,
    this.data,
    required this.timestamp,
  });

  @override
  Map<String, dynamic> toJson() => _$AppointmentResponseModelToJson(this);

  @override
  AppointmentResponseModel fromJson(Map<String, dynamic> json) => 
      _$AppointmentResponseModelFromJson(json);

  factory AppointmentResponseModel.fromJson(Map<String, dynamic> json) => 
      _$AppointmentResponseModelFromJson(json);

  bool get isSuccess => success;
}

// Single appointment API response wrapper
@JsonSerializable()
class SingleAppointmentResponseModel extends BaseModel<SingleAppointmentResponseModel> {
  final bool success;
  final String message;
  final Appointment? data;
  final DateTime timestamp;

  SingleAppointmentResponseModel({
    required this.success,
    required this.message,
    this.data,
    required this.timestamp,
  });

  @override
  Map<String, dynamic> toJson() => _$SingleAppointmentResponseModelToJson(this);

  @override
  SingleAppointmentResponseModel fromJson(Map<String, dynamic> json) => 
      _$SingleAppointmentResponseModelFromJson(json);

  factory SingleAppointmentResponseModel.fromJson(Map<String, dynamic> json) => 
      _$SingleAppointmentResponseModelFromJson(json);

  bool get isSuccess => success;
}

// Appointment model (matches backend Appointment interface exactly)
@JsonSerializable()
class Appointment {
  final String id;
  final String userId;
  final String vehicleId;
  final DateTime date;

  Appointment({
    required this.id,
    required this.userId,
    required this.vehicleId,
    required this.date,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      userId: json['userId'],
      vehicleId: json['vehicleId'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "vehicleId": vehicleId,
        "date": date.toIso8601String(),
      };

  // Convenience getters
  String get formattedDate {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String get formattedTime {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  String get formattedDateTime {
    return '$formattedDate at $formattedTime';
  }
}

// Appointment request model for creating appointments
@JsonSerializable()
class CreateAppointmentRequestModel {
  final String vehicleId;
  final String date; // ISO date string

  CreateAppointmentRequestModel({
    required this.vehicleId,
    required this.date,
  });

  Map<String, dynamic> toJson() => _$CreateAppointmentRequestModelToJson(this);

  factory CreateAppointmentRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CreateAppointmentRequestModelFromJson(json);

  // Helper factory to create from DateTime
  factory CreateAppointmentRequestModel.fromDateTime({
    required String vehicleId,
    required DateTime dateTime,
  }) {
    return CreateAppointmentRequestModel(
      vehicleId: vehicleId,
      date: dateTime.toIso8601String(),
    );
  }
} 