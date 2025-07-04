// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehicleResponseModel _$VehicleResponseModelFromJson(
  Map<String, dynamic> json,
) => VehicleResponseModel(
  success: json['success'] as bool,
  message: json['message'] as String,
  data:
      (json['data'] as List<dynamic>?)
          ?.map((e) => VehicleModel.fromJson(e as Map<String, dynamic>))
          .toList(),
  timestamp: DateTime.parse(json['timestamp'] as String),
)..localId = (json['localId'] as num?)?.toInt();

Map<String, dynamic> _$VehicleResponseModelToJson(
  VehicleResponseModel instance,
) => <String, dynamic>{
  'localId': instance.localId,
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
  'timestamp': instance.timestamp.toIso8601String(),
};

SingleVehicleResponseModel _$SingleVehicleResponseModelFromJson(
  Map<String, dynamic> json,
) => SingleVehicleResponseModel(
  success: json['success'] as bool,
  message: json['message'] as String,
  data:
      json['data'] == null
          ? null
          : VehicleModel.fromJson(json['data'] as Map<String, dynamic>),
  timestamp: DateTime.parse(json['timestamp'] as String),
)..localId = (json['localId'] as num?)?.toInt();

Map<String, dynamic> _$SingleVehicleResponseModelToJson(
  SingleVehicleResponseModel instance,
) => <String, dynamic>{
  'localId': instance.localId,
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
  'timestamp': instance.timestamp.toIso8601String(),
};

VehicleModel _$VehicleModelFromJson(Map<String, dynamic> json) => VehicleModel(
  id: json['id'] as String,
  userId: json['userId'] as String,
  plate: json['plate'] as String,
  brand: json['brand'] as String,
  model: json['model'] as String,
  year: (json['year'] as num).toInt(),
  mileage: (json['mileage'] as num).toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$VehicleModelToJson(VehicleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'plate': instance.plate,
      'brand': instance.brand,
      'model': instance.model,
      'year': instance.year,
      'mileage': instance.mileage,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

CreateVehicleRequestModel _$CreateVehicleRequestModelFromJson(
  Map<String, dynamic> json,
) => CreateVehicleRequestModel(
  plate: json['plate'] as String,
  brand: json['brand'] as String,
  model: json['model'] as String,
  year: (json['year'] as num).toInt(),
  mileage: (json['mileage'] as num).toInt(),
);

Map<String, dynamic> _$CreateVehicleRequestModelToJson(
  CreateVehicleRequestModel instance,
) => <String, dynamic>{
  'plate': instance.plate,
  'brand': instance.brand,
  'model': instance.model,
  'year': instance.year,
  'mileage': instance.mileage,
};

UpdateVehicleRequestModel _$UpdateVehicleRequestModelFromJson(
  Map<String, dynamic> json,
) => UpdateVehicleRequestModel(
  plate: json['plate'] as String?,
  brand: json['brand'] as String?,
  model: json['model'] as String?,
  year: (json['year'] as num?)?.toInt(),
  mileage: (json['mileage'] as num?)?.toInt(),
);

Map<String, dynamic> _$UpdateVehicleRequestModelToJson(
  UpdateVehicleRequestModel instance,
) => <String, dynamic>{
  if (instance.plate case final value?) 'plate': value,
  if (instance.brand case final value?) 'brand': value,
  if (instance.model case final value?) 'model': value,
  if (instance.year case final value?) 'year': value,
  if (instance.mileage case final value?) 'mileage': value,
};
