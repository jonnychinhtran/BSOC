import 'package:bsoc_book/app/models/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'list_comment_model.g.dart';

@JsonSerializable()
class ListCommentModel {
  @JsonKey(name: 'id')
  int id;
  @JsonKey(name: 'content')
  String content;
  @JsonKey(name: 'rating')
  int rating;
  @JsonKey(name: 'user')
  UserModel user;

  ListCommentModel(this.id, this.content, this.rating, this.user);

  factory ListCommentModel.fromJson(Map<String, dynamic> json) =>
      _$ListCommentModelFromJson(json);

  Map<String, dynamic> toJson() => _$ListCommentModelToJson(this);
}
