import 'package:json_annotation/json_annotation.dart';

import 'chapters_model.dart';

part 'book_model.g.dart';

@JsonSerializable()
class BookModel {
  int? id;
  @JsonKey(name: 'bookName')
  String? bookName;
  @JsonKey(name: 'author')
  String? author;
  @JsonKey(name: 'description')
  String? description;
  @JsonKey(name: 'image')
  String? image;
  @JsonKey(name: 'rating')
  double? rating;
  @JsonKey(name: 'chapters', defaultValue: [])
  List<ChaptersModel> chapters;
  @JsonKey(name: 'payment', defaultValue: false)
  bool? payment;

  BookModel(this.id, this.bookName, this.author, this.description, this.image,
      this.rating, this.chapters, this.payment);

  factory BookModel.fromJson(Map<String, dynamic> json) =>
      _$BookModelFromJson(json);

  Map<String, dynamic> toJson() => _$BookModelToJson(this);
}
