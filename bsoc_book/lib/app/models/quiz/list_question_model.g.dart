// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_question_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListQuestionModel _$ListQuestionModelFromJson(Map<String, dynamic> json) =>
    ListQuestionModel(
      id: json['id'] as int?,
      content: json['content'] as String?,
      isMultiChoice: json['isMultiChoice'] as bool? ?? false,
      totalAnswer: json['totalAnswer'] as int?,
      answers: json['answers'] == null
          ? null
          : AnswerModel.fromJson(json['answers'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ListQuestionModelToJson(ListQuestionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'isMultiChoice': instance.isMultiChoice,
      'totalAnswer': instance.totalAnswer,
      'answers': instance.answers,
    };
