// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponseModel _$LoginResponseModelFromJson(Map<String, dynamic> json) =>
    LoginResponseModel(
      id: json['id'] as int?,
      username: json['username'] as String?,
      email: json['email'] as String?,
      tokenType: json['tokenType'] as String?,
      accessToken: json['accessToken'] as String?,
    );

Map<String, dynamic> _$LoginResponseModelToJson(LoginResponseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'accessToken': instance.accessToken,
      'tokenType': instance.tokenType,
    };
