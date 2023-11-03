// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_bookmark_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListBookmarkModel _$ListBookmarkModelFromJson(Map<String, dynamic> json) =>
    ListBookmarkModel(
      json['id'] as int,
      ChaptersModel.fromJson(json['chapter'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ListBookmarkModelToJson(ListBookmarkModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'chapter': instance.chapter,
    };
