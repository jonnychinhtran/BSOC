// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapters_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChaptersModel _$ChaptersModelFromJson(Map<String, dynamic> json) =>
    ChaptersModel(
      json['id'] as int?,
      json['chapterId'] as int?,
      json['chapterTitle'] as String,
      json['filePath'] as String,
      json['first'] as bool?,
      json['last'] as bool?,
      json['downloaded'] as bool?,
      json['bookmark'] as bool?,
      json['allow'] as bool?,
    );

Map<String, dynamic> _$ChaptersModelToJson(ChaptersModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'chapterId': instance.chapterId,
      'chapterTitle': instance.chapterTitle,
      'filePath': instance.filePath,
      'first': instance.first,
      'last': instance.last,
      'downloaded': instance.downloaded,
      'bookmark': instance.bookmark,
      'allow': instance.allow,
    };
