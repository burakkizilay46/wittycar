import 'package:json_annotation/json_annotation.dart';
import 'package:wittycar_mobile/core/base/model/base_model.dart';

part 'service_record_model.g.dart';

// Service Records API response wrapper
@JsonSerializable()
class ServiceRecordResponseModel extends BaseModel<ServiceRecordResponseModel> {
  final bool success;
  final String message;
  final List<ServiceRecord>? data;
  final DateTime timestamp;

  ServiceRecordResponseModel({
    required this.success,
    required this.message,
    this.data,
    required this.timestamp,
  });

  @override
  Map<String, dynamic> toJson() => _$ServiceRecordResponseModelToJson(this);

  @override
  ServiceRecordResponseModel fromJson(Map<String, dynamic> json) => 
      _$ServiceRecordResponseModelFromJson(json);

  factory ServiceRecordResponseModel.fromJson(Map<String, dynamic> json) => 
      _$ServiceRecordResponseModelFromJson(json);

  bool get isSuccess => success;
}

// Single service record API response wrapper
@JsonSerializable()
class SingleServiceRecordResponseModel extends BaseModel<SingleServiceRecordResponseModel> {
  final bool success;
  final String message;
  final ServiceRecord? data;
  final DateTime timestamp;

  SingleServiceRecordResponseModel({
    required this.success,
    required this.message,
    this.data,
    required this.timestamp,
  });

  @override
  Map<String, dynamic> toJson() => _$SingleServiceRecordResponseModelToJson(this);

  @override
  SingleServiceRecordResponseModel fromJson(Map<String, dynamic> json) => 
      _$SingleServiceRecordResponseModelFromJson(json);

  factory SingleServiceRecordResponseModel.fromJson(Map<String, dynamic> json) => 
      _$SingleServiceRecordResponseModelFromJson(json);

  bool get isSuccess => success;
}

// Service Record model (matches backend ServiceRecord interface exactly)
@JsonSerializable()
class ServiceRecord {
  final String id;
  final String vehicleId;
  final String userId;
  final String title;
  final String description;
  final String date; // ISO date string
  final int mileage;
  final DateTime createdAt;
  final DateTime updatedAt;

  ServiceRecord({
    required this.id,
    required this.vehicleId,
    required this.userId,
    required this.title,
    required this.description,
    required this.date,
    required this.mileage,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => _$ServiceRecordToJson(this);

  factory ServiceRecord.fromJson(Map<String, dynamic> json) => 
      _$ServiceRecordFromJson(json);

  // Convenience getters
  DateTime get dateTime => DateTime.parse(date);
  String get formattedDate {
    final dt = dateTime;
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }
}

// Service record request model for creating service records
@JsonSerializable()
class CreateServiceRecordRequestModel {
  final String title;
  final String description;
  final String date; // ISO date string
  final int mileage;

  CreateServiceRecordRequestModel({
    required this.title,
    required this.description,
    required this.date,
    required this.mileage,
  });

  Map<String, dynamic> toJson() => _$CreateServiceRecordRequestModelToJson(this);

  factory CreateServiceRecordRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CreateServiceRecordRequestModelFromJson(json);
} 