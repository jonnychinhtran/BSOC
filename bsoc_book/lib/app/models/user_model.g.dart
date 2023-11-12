// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as int?,
      username: json['username'] as String?,
      email: json['email'] as String?,
      roles: (json['roles'] as List<dynamic>?)
          ?.map((e) => RolesModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      image: json['image'] as String?,
      avatar: json['avatar'] as String?,
      books: (json['books'] as List<dynamic>?)
          ?.map((e) => BookModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      chapters: (json['chapters'] as List<dynamic>?)
          ?.map((e) => ChaptersModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      fullname: json['fullname'] as String?,
      pointForClaimBook: json['pointForClaimBook'] as int? ?? 0,
      spinTurn: json['spinTurn'] as int? ?? 0,
      active: json['active'] as bool?,
    )..phone = json['phone'] as String?;

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'phone': instance.phone,
      'roles': instance.roles,
      'image': instance.image,
      'avatar': instance.avatar,
      'books': instance.books,
      'chapters': instance.chapters,
      'fullname': instance.fullname,
      'pointForClaimBook': instance.pointForClaimBook,
      'spinTurn': instance.spinTurn,
      'active': instance.active,
    };
