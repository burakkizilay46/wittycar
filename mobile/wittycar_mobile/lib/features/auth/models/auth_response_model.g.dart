// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthResponseModel _$AuthResponseModelFromJson(Map<String, dynamic> json) =>
    AuthResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data:
          json['data'] == null
              ? null
              : AuthDataModel.fromJson(json['data'] as Map<String, dynamic>),
      timestamp: json['timestamp'] as String?,
    )..localId = (json['localId'] as num?)?.toInt();

Map<String, dynamic> _$AuthResponseModelToJson(AuthResponseModel instance) =>
    <String, dynamic>{
      'localId': instance.localId,
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
      'timestamp': instance.timestamp,
    };

AuthDataModel _$AuthDataModelFromJson(Map<String, dynamic> json) =>
    AuthDataModel(
      token: json['token'] as String,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AuthDataModelToJson(AuthDataModel instance) =>
    <String, dynamic>{'token': instance.token, 'user': instance.user};

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  uid: json['uid'] as String,
  email: json['email'] as String,
  displayName: json['displayName'] as String?,
  phoneNumber: json['phoneNumber'] as String?,
  emailVerified: json['emailVerified'] as bool?,
  isActive: json['isActive'] as bool?,
  createdAtTimestamp: json['createdAt'] as Map<String, dynamic>?,
  updatedAtTimestamp: json['updatedAt'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'uid': instance.uid,
  'email': instance.email,
  'displayName': instance.displayName,
  'phoneNumber': instance.phoneNumber,
  'emailVerified': instance.emailVerified,
  'isActive': instance.isActive,
  'createdAt': instance.createdAtTimestamp,
  'updatedAt': instance.updatedAtTimestamp,
};
