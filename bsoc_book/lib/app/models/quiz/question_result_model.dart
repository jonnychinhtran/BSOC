import 'package:json_annotation/json_annotation.dart';
part 'question_result_model.g.dart';

@JsonSerializable()
class QuestionResultModel {
  @JsonKey(name: "totalCorrect", defaultValue: 0)
  int? totalCorrect;
  @JsonKey(name: "totalWrong", defaultValue: 0)
  int? totalWrong;

  QuestionResultModel({this.totalCorrect, this.totalWrong});

  factory QuestionResultModel.fromJson(Map<String, dynamic> json) =>
      _$QuestionResultModelFromJson(json);
  Map<String, dynamic> toJson() => _$QuestionResultModelToJson(this);
}
