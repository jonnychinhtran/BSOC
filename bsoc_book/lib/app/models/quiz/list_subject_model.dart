import 'package:json_annotation/json_annotation.dart';
part 'list_subject_model.g.dart';

@JsonSerializable()
class ListSubjectModel {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "name")
  String? name;

  ListSubjectModel({this.id, this.name});

  factory ListSubjectModel.fromJson(Map<String, dynamic> json) =>
      _$ListSubjectModelFromJson(json);
  Map<String, dynamic> toJson() => _$ListSubjectModelToJson(this);
}
