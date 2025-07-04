import 'package:json_annotation/json_annotation.dart';
import 'package:wittycar_mobile/core/base/model/base_model.dart';

part 'auth_request_model.g.dart';

@JsonSerializable()
class AuthRequestModel extends BaseModel<AuthRequestModel> {
  final String email;
  final String password;
  @JsonKey(includeIfNull: false)
  final String? displayName; // For register request - matches backend field
  @JsonKey(includeIfNull: false)
  final String? phoneNumber; // For register request - E.164 format

  AuthRequestModel({
    required this.email,
    required this.password,
    this.displayName,
    this.phoneNumber,
  });

  @override
  Map<String, dynamic> toJson() => _$AuthRequestModelToJson(this);

  @override
  AuthRequestModel fromJson(Map<String, dynamic> json) =>
      _$AuthRequestModelFromJson(json);

  factory AuthRequestModel.fromJson(Map<String, dynamic> json) =>
      _$AuthRequestModelFromJson(json);

  // Factory constructors for different request types
  factory AuthRequestModel.login({
    required String email,
    required String password,
  }) {
    return AuthRequestModel(email: email, password: password);
  }

  factory AuthRequestModel.register({
    required String email,
    required String password,
    required String displayName,
    required String phoneNumber,
  }) {
    return AuthRequestModel(
      email: email,
      password: password,
      displayName: displayName,
      phoneNumber: phoneNumber,
    );
  }
}
