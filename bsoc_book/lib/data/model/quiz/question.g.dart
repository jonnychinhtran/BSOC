// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Question _$QuestionFromJson(Map<String, dynamic> json) => Question(
      json['id'] as int,
      json['content'] as String,
      json['isMultiChoice'] as bool? ?? false,
      json['totalAnswer'] as int,
      (json['answers'] as List<dynamic>)
          .map((e) => Answers.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$QuestionToJson(Question instance) => <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'isMultiChoice': instance.isMultiChoice,
      'totalAnswer': instance.totalAnswer,
      'answers': instance.answers,
    };
