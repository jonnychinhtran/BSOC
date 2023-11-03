import 'package:json_annotation/json_annotation.dart';

part 'top_book_model.g.dart';

@JsonSerializable()
class TopBookModel {
  @JsonKey(name: 'id')
  int id;
  @JsonKey(name: 'bookName')
  String bookName;
  @JsonKey(name: 'author')
  String author;
  @JsonKey(name: 'description')
  String description;
  @JsonKey(name: 'image')
  String image;
  @JsonKey(name: 'rating')
  double rating;

  TopBookModel(this.id, this.bookName, this.author, this.description,
      this.image, this.rating);

  factory TopBookModel.fromJson(Map<String, dynamic> json) =>
      _$TopBookModelFromJson(json);

  Map<String, dynamic> toJson() => _$TopBookModelToJson(this);
}
