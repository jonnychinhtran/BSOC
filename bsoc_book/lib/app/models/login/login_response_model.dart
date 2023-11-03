import 'package:json_annotation/json_annotation.dart';

import '../roles_model.dart';

part 'login_response_model.g.dart';

@JsonSerializable()
class LoginResponseModel {
  int? id;
  @JsonKey(name: "username")
  String? username;
  @JsonKey(name: "email")
  String? email;
  @JsonKey(name: "accessToken")
  String? accessToken;
  @JsonKey(name: "tokenType")
  String? tokenType;

  LoginResponseModel(
      {this.id, this.username, this.email, this.tokenType, this.accessToken});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$LoginResponseModelToJson(this);
}
