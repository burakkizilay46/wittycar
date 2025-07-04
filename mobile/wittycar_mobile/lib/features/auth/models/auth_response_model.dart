import 'package:json_annotation/json_annotation.dart';
import 'package:wittycar_mobile/core/base/model/base_model.dart';

part 'auth_response_model.g.dart';

// Main API response wrapper that matches backend format
@JsonSerializable()
class AuthResponseModel extends BaseModel<AuthResponseModel> {
  final bool success;
  final String message;
  final AuthDataModel? data;
  final String? timestamp;

  AuthResponseModel({
    required this.success,
    required this.message,
    this.data,
    this.timestamp,
  });

  @override
  Map<String, dynamic> toJson() => _$AuthResponseModelToJson(this);

  @override
  AuthResponseModel fromJson(Map<String, dynamic> json) => 
      _$AuthResponseModelFromJson(json);

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) => 
      _$AuthResponseModelFromJson(json);

  // Convenience getters for easier access
  String? get token => data?.token;
  UserModel? get user => data?.user;
  bool get isSuccess => success;
}

// Auth data model that contains user and token info
@JsonSerializable()
class AuthDataModel {
  final String token;
  final UserModel user;

  AuthDataModel({
    required this.token,
    required this.user,
  });

  Map<String, dynamic> toJson() => _$AuthDataModelToJson(this);

  factory AuthDataModel.fromJson(Map<String, dynamic> json) => 
      _$AuthDataModelFromJson(json);
}

// User model that matches backend user structure
@JsonSerializable()
class UserModel {
  final String uid;
  final String email;
  final String? displayName;
  final String? phoneNumber;
  final bool? emailVerified;
  final bool? isActive;
  @JsonKey(name: 'createdAt')
  final String? createdAt;
  @JsonKey(name: 'updatedAt') 
  final String? updatedAt;

  UserModel({
    required this.uid,
    required this.email,
    this.displayName,
    this.phoneNumber,
    this.emailVerified,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  factory UserModel.fromJson(Map<String, dynamic> json) => 
      _$UserModelFromJson(json);

  // Convenience getters
  String get id => uid;
  String get fullName => displayName ?? '';
} 