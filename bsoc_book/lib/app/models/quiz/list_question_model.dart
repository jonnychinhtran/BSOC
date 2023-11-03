import 'package:bsoc_book/app/models/quiz/answer_model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'list_question_model.g.dart';

@JsonSerializable()
class ListQuestionModel {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "content")
  String? content;
  @JsonKey(name: "isMultiChoice", defaultValue: false)
  bool? isMultiChoice;
  @JsonKey(name: "totalAnswer")
  int? totalAnswer;
  @JsonKey(name: "answers")
  AnswerModel? answers;

  ListQuestionModel(
      {this.id,
      this.content,
      this.isMultiChoice,
      this.totalAnswer,
      this.answers});

  factory ListQuestionModel.fromJson(Map<String, dynamic> json) =>
      _$ListQuestionModelFromJson(json);
  Map<String, dynamic> toJson() => _$ListQuestionModelToJson(this);
}
