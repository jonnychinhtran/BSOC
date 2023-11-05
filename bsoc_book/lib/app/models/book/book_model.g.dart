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
      (json['chapters'] as List<dynamic>?)
              ?.map((e) => ChaptersModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      json['payment'] as bool? ?? false,
    );

Map<String, dynamic> _$BookModelToJson(BookModel instance) => <String, dynamic>{
      'id': instance.id,
      'bookName': instance.bookName,
      'author': instance.author,
      'description': instance.description,
      'image': instance.image,
      'rating': instance.rating,
      'chapters': instance.chapters,
      'payment': instance.payment,
    };
