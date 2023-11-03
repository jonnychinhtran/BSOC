import 'package:bsoc_book/app/models/book/chapters_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'list_bookmark_model.g.dart';

@JsonSerializable()
class ListBookmarkModel {
  @JsonKey(name: 'id')
  int id;
  @JsonKey(name: 'chapter')
  ChaptersModel chapter;

  ListBookmarkModel(this.id, this.chapter);

  factory ListBookmarkModel.fromJson(Map<String, dynamic> json) =>
      _$ListBookmarkModelFromJson(json);

  Map<String, dynamic> toJson() => _$ListBookmarkModelToJson(this);
}
