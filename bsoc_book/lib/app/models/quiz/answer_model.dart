import 'package:json_annotation/json_annotation.dart';
part 'answer_model.g.dart';

@JsonSerializable()
class AnswerModel {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "content")
  String? content;
  @JsonKey(name: "isCorrect")
  bool? isCorrect;

  AnswerModel({this.id, this.content, this.isCorrect});

  factory AnswerModel.fromJson(Map<String, dynamic> json) =>
      _$AnswerModelFromJson(json);
  Map<String, dynamic> toJson() => _$AnswerModelToJson(this);
}
