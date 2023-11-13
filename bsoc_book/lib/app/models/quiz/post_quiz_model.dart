import 'package:bsoc_book/app/models/quiz/answer_model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'post_quiz_model.g.dart';

@JsonSerializable()
class PostQuizModel {
  @JsonKey(name: "questionId")
  int? questionId;
  @JsonKey(name: "answerId")
  List<dynamic>? answerId;

  PostQuizModel({
    this.questionId,
    this.answerId,
  });

  factory PostQuizModel.fromJson(Map<String, dynamic> json) =>
      _$PostQuizModelFromJson(json);
  Map<String, dynamic> toJson() => _$PostQuizModelToJson(this);
}
