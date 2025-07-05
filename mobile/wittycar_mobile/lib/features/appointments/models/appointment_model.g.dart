// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppointmentResponseModel _$AppointmentResponseModelFromJson(
  Map<String, dynamic> json,
) => AppointmentResponseModel(
  success: json['success'] as bool,
  message: json['message'] as String,
  data:
      (json['data'] as List<dynamic>?)
          ?.map((e) => Appointment.fromJson(e as Map<String, dynamic>))
          .toList(),
  timestamp: DateTime.parse(json['timestamp'] as String),
)..localId = (json['localId'] as num?)?.toInt();

Map<String, dynamic> _$AppointmentResponseModelToJson(
  AppointmentResponseModel instance,
) => <String, dynamic>{
  'localId': instance.localId,
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
  'timestamp': instance.timestamp.toIso8601String(),
};

SingleAppointmentResponseModel _$SingleAppointmentResponseModelFromJson(
  Map<String, dynamic> json,
) => SingleAppointmentResponseModel(
  success: json['success'] as bool,
  message: json['message'] as String,
  data:
      json['data'] == null
          ? null
          : Appointment.fromJson(json['data'] as Map<String, dynamic>),
  timestamp: DateTime.parse(json['timestamp'] as String),
)..localId = (json['localId'] as num?)?.toInt();

Map<String, dynamic> _$SingleAppointmentResponseModelToJson(
  SingleAppointmentResponseModel instance,
) => <String, dynamic>{
  'localId': instance.localId,
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
  'timestamp': instance.timestamp.toIso8601String(),
};

Appointment _$AppointmentFromJson(Map<String, dynamic> json) =>
    Appointment(
      id: json['id'] as String,
      userId: json['userId'] as String,
      vehicleId: json['vehicleId'] as String,
      date: DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$AppointmentToJson(Appointment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'vehicleId': instance.vehicleId,
      'date': instance.date.toIso8601String(),
    };

CreateAppointmentRequestModel _$CreateAppointmentRequestModelFromJson(
  Map<String, dynamic> json,
) => CreateAppointmentRequestModel(
  vehicleId: json['vehicleId'] as String,
  date: json['date'] as String,
);

Map<String, dynamic> _$CreateAppointmentRequestModelToJson(
  CreateAppointmentRequestModel instance,
) => <String, dynamic>{
  'vehicleId': instance.vehicleId,
  'date': instance.date,
};
