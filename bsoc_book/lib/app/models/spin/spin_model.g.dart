// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spin_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpinModel _$SpinModelFromJson(Map<String, dynamic> json) => SpinModel(
      json['id'] as int,
      json['name'] as String,
      json['isActive'] as bool,
      json['voucherType'] as String,
    );

Map<String, dynamic> _$SpinModelToJson(SpinModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'isActive': instance.isActive,
      'voucherType': instance.voucherType,
    };
