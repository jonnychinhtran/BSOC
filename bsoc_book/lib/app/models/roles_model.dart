import 'package:json_annotation/json_annotation.dart';
part 'roles_model.g.dart';

@JsonSerializable()
class RolesModel {
  int? id;
  @JsonKey(name: "name")
  String? name;

  RolesModel({this.id, this.name});

  factory RolesModel.fromJson(Map<String, dynamic> json) =>
      _$RolesModelFromJson(json);
  Map<String, dynamic> toJson() => _$RolesModelToJson(this);
}
