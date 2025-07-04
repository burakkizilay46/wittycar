// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthRequestModel _$AuthRequestModelFromJson(Map<String, dynamic> json) =>
    AuthRequestModel(
      email: json['email'] as String,
      password: json['password'] as String,
      displayName: json['displayName'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
    )..localId = (json['localId'] as num?)?.toInt();

Map<String, dynamic> _$AuthRequestModelToJson(AuthRequestModel instance) =>
    <String, dynamic>{
      'localId': instance.localId,
      'email': instance.email,
      'password': instance.password,
      if (instance.displayName case final value?) 'displayName': value,
      if (instance.phoneNumber case final value?) 'phoneNumber': value,
    };
