import 'package:json_annotation/json_annotation.dart';

part 'book_model.g.dart';

@JsonSerializable()
class BookModel {
  @JsonKey(name: 'id')
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

  BookModel(this.id, this.bookName, this.author, this.description, this.image,
      this.rating);

  factory BookModel.fromJson(Map<String, dynamic> json) =>
      _$BookModelFromJson(json);

  Map<String, dynamic> toJson() => _$BookModelToJson(this);
}
