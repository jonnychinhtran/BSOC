// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookModel _$BookModelFromJson(Map<String, dynamic> json) => BookModel(
      json['id'] as int?,
      json['bookName'] as String?,
      json['author'] as String?,
      json['description'] as String?,
      json['image'] as String?,
      (json['rating'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$BookModelToJson(BookModel instance) => <String, dynamic>{
      'id': instance.id,
      'bookName': instance.bookName,
      'author': instance.author,
      'description': instance.description,
      'image': instance.image,
      'rating': instance.rating,
    };
