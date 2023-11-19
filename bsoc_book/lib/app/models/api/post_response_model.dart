import 'package:json_annotation/json_annotation.dart';

part 'post_response_model.g.dart';

@JsonSerializable()
class PostReponseModel {
  @JsonKey(name: 'statusCode')
  int? statusCode;
  @JsonKey(name: 'data')
  String? data;

  PostReponseModel(this.statusCode, this.data);

  factory PostReponseModel.fromJson(Map<String, dynamic> json) =>
      _$PostReponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostReponseModelToJson(this);
}
