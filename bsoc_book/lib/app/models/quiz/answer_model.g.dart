// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'answer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnswerModel _$AnswerModelFromJson(Map<String, dynamic> json) => AnswerModel(
      id: json['id'] as int?,
      content: json['content'] as String?,
      isCorrect: json['isCorrect'] as bool?,
    );

Map<String, dynamic> _$AnswerModelToJson(AnswerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'isCorrect': instance.isCorrect,
    };
