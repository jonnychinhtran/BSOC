import 'package:json_annotation/json_annotation.dart';
part 'subject_info_model.g.dart';

@JsonSerializable()
class SubjectInfoModel {
  @JsonKey(name: "totalQuestion")
  int? totalQuestion;
  @JsonKey(name: "duration")
  int? duration;

  SubjectInfoModel({this.totalQuestion, this.duration});

  factory SubjectInfoModel.fromJson(Map<String, dynamic> json) =>
      _$SubjectInfoModelFromJson(json);
  Map<String, dynamic> toJson() => _$SubjectInfoModelToJson(this);
}
