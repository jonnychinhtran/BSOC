// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'top_book_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TopBookModel _$TopBookModelFromJson(Map<String, dynamic> json) => TopBookModel(
      json['id'] as int,
      json['bookName'] as String,
      json['author'] as String,
      json['description'] as String,
      json['image'] as String,
      (json['rating'] as num).toDouble(),
    );

Map<String, dynamic> _$TopBookModelToJson(TopBookModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bookName': instance.bookName,
      'author': instance.author,
      'description': instance.description,
      'image': instance.image,
      'rating': instance.rating,
    };
