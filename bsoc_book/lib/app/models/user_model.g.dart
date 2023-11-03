// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as int?,
      username: json['username'] as String?,
      email: json['email'] as String?,
      roles: json['roles'] == null
          ? null
          : RolesModel.fromJson(json['roles'] as Map<String, dynamic>),
      image: json['image'] as String?,
      avatar: json['avatar'] as String?,
      fullname: json['fullname'] as String?,
      pointForClaimBook: json['pointForClaimBook'] as int?,
      spinTurn: json['spinTurn'] as int?,
      active: json['active'] as bool? ?? true,
    )..phone = json['phone'] as String?;

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'phone': instance.phone,
      'roles': instance.roles,
      'image': instance.image,
      'avatar': instance.avatar,
      'fullname': instance.fullname,
      'pointForClaimBook': instance.pointForClaimBook,
      'spinTurn': instance.spinTurn,
      'active': instance.active,
    };
