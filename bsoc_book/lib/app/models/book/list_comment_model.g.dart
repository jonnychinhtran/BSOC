// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListCommentModel _$ListCommentModelFromJson(Map<String, dynamic> json) =>
    ListCommentModel(
      json['id'] as int,
      json['content'] as String,
      json['rating'] as int,
      UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ListCommentModelToJson(ListCommentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'rating': instance.rating,
      'user': instance.user,
    };
