// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuestionResultModel _$QuestionResultModelFromJson(Map<String, dynamic> json) =>
    QuestionResultModel(
      totalCorrect: json['totalCorrect'] as int? ?? 0,
      totalWrong: json['totalWrong'] as int? ?? 0,
    );

Map<String, dynamic> _$QuestionResultModelToJson(
        QuestionResultModel instance) =>
    <String, dynamic>{
      'totalCorrect': instance.totalCorrect,
      'totalWrong': instance.totalWrong,
    };
