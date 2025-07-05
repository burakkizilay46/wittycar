// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_record_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceRecordResponseModel _$ServiceRecordResponseModelFromJson(
  Map<String, dynamic> json,
) => ServiceRecordResponseModel(
  success: json['success'] as bool,
  message: json['message'] as String,
  data:
      (json['data'] as List<dynamic>?)
          ?.map((e) => ServiceRecord.fromJson(e as Map<String, dynamic>))
          .toList(),
  timestamp: DateTime.parse(json['timestamp'] as String),
)..localId = (json['localId'] as num?)?.toInt();

Map<String, dynamic> _$ServiceRecordResponseModelToJson(
  ServiceRecordResponseModel instance,
) => <String, dynamic>{
  'localId': instance.localId,
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
  'timestamp': instance.timestamp.toIso8601String(),
};

SingleServiceRecordResponseModel _$SingleServiceRecordResponseModelFromJson(
  Map<String, dynamic> json,
) => SingleServiceRecordResponseModel(
  success: json['success'] as bool,
  message: json['message'] as String,
  data:
      json['data'] == null
          ? null
          : ServiceRecord.fromJson(json['data'] as Map<String, dynamic>),
  timestamp: DateTime.parse(json['timestamp'] as String),
)..localId = (json['localId'] as num?)?.toInt();

Map<String, dynamic> _$SingleServiceRecordResponseModelToJson(
  SingleServiceRecordResponseModel instance,
) => <String, dynamic>{
  'localId': instance.localId,
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
  'timestamp': instance.timestamp.toIso8601String(),
};

ServiceRecord _$ServiceRecordFromJson(Map<String, dynamic> json) =>
    ServiceRecord(
      id: json['id'] as String,
      vehicleId: json['vehicleId'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      date: json['date'] as String,
      mileage: (json['mileage'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ServiceRecordToJson(ServiceRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vehicleId': instance.vehicleId,
      'userId': instance.userId,
      'title': instance.title,
      'description': instance.description,
      'date': instance.date,
      'mileage': instance.mileage,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

CreateServiceRecordRequestModel _$CreateServiceRecordRequestModelFromJson(
  Map<String, dynamic> json,
) => CreateServiceRecordRequestModel(
  title: json['title'] as String,
  description: json['description'] as String,
  date: json['date'] as String,
  mileage: (json['mileage'] as num).toInt(),
);

Map<String, dynamic> _$CreateServiceRecordRequestModelToJson(
  CreateServiceRecordRequestModel instance,
) => <String, dynamic>{
  'title': instance.title,
  'description': instance.description,
  'date': instance.date,
  'mileage': instance.mileage,
};
