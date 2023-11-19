import 'package:bsoc_book/app/models/book/book_model.dart';
import 'package:bsoc_book/app/models/book/chapters_model.dart';
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
  List<RolesModel>? roles;
  @JsonKey(name: "image")
  String? image;
  @JsonKey(name: "avatar")
  String? avatar;
  @JsonKey(name: "books")
  List<BookModel>? books;
  @JsonKey(name: "chapters")
  List<ChaptersModel>? chapters;
  @JsonKey(name: "fullname")
  String? fullname;
  @JsonKey(name: "pointForClaimBook", defaultValue: 0)
  int? pointForClaimBook;
  @JsonKey(name: "spinTurn", defaultValue: 0)
  int? spinTurn;
  @JsonKey(name: "active")
  bool? active;

  UserModel(
      {this.id,
      this.username,
      this.email,
      this.roles,
      this.image,
      this.avatar,
      this.books,
      this.chapters,
      this.fullname,
      this.pointForClaimBook,
      this.spinTurn,
      this.active});

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}