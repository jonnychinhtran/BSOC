import 'package:bsoc_book/app/models/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'spin_model.g.dart';

@JsonSerializable()
class SpinModel {
  @JsonKey(name: 'id')
  int id;
  @JsonKey(name: 'name')
  String name;
  @JsonKey(name: 'isActive')
  bool isActive;
  @JsonKey(name: 'voucherType')
  String voucherType;

  SpinModel(this.id, this.name, this.isActive, this.voucherType);

  factory SpinModel.fromJson(Map<String, dynamic> json) =>
      _$SpinModelFromJson(json);

  Map<String, dynamic> toJson() => _$SpinModelToJson(this);
}
