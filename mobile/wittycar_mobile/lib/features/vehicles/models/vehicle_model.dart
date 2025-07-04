import 'package:json_annotation/json_annotation.dart';
import 'package:wittycar_mobile/core/base/model/base_model.dart';

part 'vehicle_model.g.dart';

// Vehicle API response wrapper (VehiclesResponse backend'te)
@JsonSerializable()
class VehicleResponseModel extends BaseModel<VehicleResponseModel> {
  final bool success;
  final String message;
  final List<VehicleModel>? data;
  final DateTime timestamp;

  VehicleResponseModel({
    required this.success,
    required this.message,
    this.data,
    required this.timestamp,
  });

  @override
  Map<String, dynamic> toJson() => _$VehicleResponseModelToJson(this);

  @override
  VehicleResponseModel fromJson(Map<String, dynamic> json) => 
      _$VehicleResponseModelFromJson(json);

  factory VehicleResponseModel.fromJson(Map<String, dynamic> json) => 
      _$VehicleResponseModelFromJson(json);

  bool get isSuccess => success;
}

// Single vehicle API response wrapper (VehicleResponse backend'te)
@JsonSerializable()
class SingleVehicleResponseModel extends BaseModel<SingleVehicleResponseModel> {
  final bool success;
  final String message;
  final VehicleModel? data;
  final DateTime timestamp;

  SingleVehicleResponseModel({
    required this.success,
    required this.message,
    this.data,
    required this.timestamp,
  });

  @override
  Map<String, dynamic> toJson() => _$SingleVehicleResponseModelToJson(this);

  @override
  SingleVehicleResponseModel fromJson(Map<String, dynamic> json) => 
      _$SingleVehicleResponseModelFromJson(json);

  factory SingleVehicleResponseModel.fromJson(Map<String, dynamic> json) => 
      _$SingleVehicleResponseModelFromJson(json);

  bool get isSuccess => success;
}

// Vehicle model (Backend Vehicle interface'ine göre)
@JsonSerializable()
class VehicleModel {
  final String id;
  final String userId;
  final String plate;
  final String brand;
  final String model;
  final int year;
  final int mileage;
  final DateTime createdAt;
  final DateTime updatedAt;

  VehicleModel({
    required this.id,
    required this.userId,
    required this.plate,
    required this.brand,
    required this.model,
    required this.year,
    required this.mileage,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => _$VehicleModelToJson(this);

  factory VehicleModel.fromJson(Map<String, dynamic> json) => 
      _$VehicleModelFromJson(json);

  // Convenience getters
  String get displayName => '$year $brand $model';
  String get plateDisplay => plate.toUpperCase();
}

// Vehicle request model for creating vehicles (Backend CreateVehicleRequest'e göre)
@JsonSerializable()
class CreateVehicleRequestModel {
  final String plate;
  final String brand;
  final String model;
  final int year;
  final int mileage;

  CreateVehicleRequestModel({
    required this.plate,
    required this.brand,
    required this.model,
    required this.year,
    required this.mileage,
  });

  Map<String, dynamic> toJson() => _$CreateVehicleRequestModelToJson(this);

  factory CreateVehicleRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CreateVehicleRequestModelFromJson(json);
}

// Vehicle request model for updating vehicles (Backend UpdateVehicleRequest'e göre)
@JsonSerializable()
class UpdateVehicleRequestModel {
  @JsonKey(includeIfNull: false)
  final String? plate;
  @JsonKey(includeIfNull: false)
  final String? brand;
  @JsonKey(includeIfNull: false)
  final String? model;
  @JsonKey(includeIfNull: false)
  final int? year;
  @JsonKey(includeIfNull: false)
  final int? mileage;

  UpdateVehicleRequestModel({
    this.plate,
    this.brand,
    this.model,
    this.year,
    this.mileage,
  });

  Map<String, dynamic> toJson() => _$UpdateVehicleRequestModelToJson(this);

  factory UpdateVehicleRequestModel.fromJson(Map<String, dynamic> json) =>
      _$UpdateVehicleRequestModelFromJson(json);
} 