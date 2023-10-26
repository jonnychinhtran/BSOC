// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'answers_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Answers _$AnswersFromJson(Map<String, dynamic> json) => Answers(
      json['id'] as int,
      json['content'] as String,
      json['isCorrect'] as bool,
    );

Map<String, dynamic> _$AnswersToJson(Answers instance) => <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'isCorrect': instance.isCorrect,
    };
