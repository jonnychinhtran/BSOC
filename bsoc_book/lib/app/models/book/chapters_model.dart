import 'package:bsoc_book/app/models/book/book_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chapters_model.g.dart';

@JsonSerializable()
class ChaptersModel {
  @JsonKey(name: 'id')
  int id;
  @JsonKey(name: 'chapterId')
  int chapterId;
  @JsonKey(name: 'chapterTitle')
  String chapterTitle;
  @JsonKey(name: 'filePath')
  String filePath;
  @JsonKey(name: 'first')
  bool first;
  @JsonKey(name: 'last')
  bool last;
  @JsonKey(name: 'downloaded')
  bool downloaded;
  @JsonKey(name: 'bookmark')
  bool bookmark;
  @JsonKey(name: 'allow')
  bool allow;
  @JsonKey(name: 'book')
  BookModel book;

  ChaptersModel(
      this.id,
      this.chapterId,
      this.chapterTitle,
      this.filePath,
      this.first,
      this.last,
      this.downloaded,
      this.bookmark,
      this.allow,
      this.book);

  factory ChaptersModel.fromJson(Map<String, dynamic> json) =>
      _$ChaptersModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChaptersModelToJson(this);
}
