import 'package:bsoc_book/app/models/roles_model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  int? id;
  @JsonKey(name: "username")
  String? username;
  @JsonKey(name: "email")
  String? email;
  @JsonKey(name: "phone")
  String? phone;
  @JsonKey(name: "roles")
  RolesModel? roles;
  @JsonKey(name: "image")
  String? image;
  @JsonKey(name: "avatar")
  String? avatar;
  @JsonKey(name: "fullname")
  String? fullname;
  int? pointForClaimBook;
  int? spinTurn;
  bool active;

  UserModel(
      {this.id,
      this.username,
      this.email,
      this.roles,
      this.image,
      this.avatar,
      this.fullname,
      this.pointForClaimBook,
      this.spinTurn,
      this.active = true});

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
