// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_quiz_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostQuizModel _$PostQuizModelFromJson(Map<String, dynamic> json) =>
    PostQuizModel(
      questionId: json['questionId'] as int?,
      answerId: json['answerId'] as List<dynamic>?,
    );

Map<String, dynamic> _$PostQuizModelToJson(PostQuizModel instance) =>
    <String, dynamic>{
      'questionId': instance.questionId,
      'answerId': instance.answerId,
    };
