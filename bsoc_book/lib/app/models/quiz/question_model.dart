import 'package:bsoc_book/app/models/quiz/list_question_model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'question_model.g.dart';

@JsonSerializable()
class QuestionModel {
  @JsonKey(name: "totalQuestion")
  int? totalQuestion;
  @JsonKey(name: "duration")
  int? duration;
  @JsonKey(name: "listQuestion")
  ListQuestionModel? listQuestion;

  QuestionModel({this.totalQuestion, this.duration, this.listQuestion});

  factory QuestionModel.fromJson(Map<String, dynamic> json) =>
      _$QuestionModelFromJson(json);
  Map<String, dynamic> toJson() => _$QuestionModelToJson(this);
}
