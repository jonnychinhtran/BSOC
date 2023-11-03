// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuestionModel _$QuestionModelFromJson(Map<String, dynamic> json) =>
    QuestionModel(
      totalQuestion: json['totalQuestion'] as int?,
      duration: json['duration'] as int?,
      listQuestion: json['listQuestion'] == null
          ? null
          : ListQuestionModel.fromJson(
              json['listQuestion'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$QuestionModelToJson(QuestionModel instance) =>
    <String, dynamic>{
      'totalQuestion': instance.totalQuestion,
      'duration': instance.duration,
      'listQuestion': instance.listQuestion,
    };
