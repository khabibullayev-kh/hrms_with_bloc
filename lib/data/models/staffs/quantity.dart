import 'package:json_annotation/json_annotation.dart';

part 'quantity.g.dart';

@JsonSerializable()
class Quantity {
  int id;
  String name;
  int value;

  Quantity({
    required this.id,
    required this.name,
    required this.value,
  });

  factory Quantity.fromJson(Map<String, dynamic> json) => _$QuantityFromJson(json);

  Map<String, dynamic> toJson() => _$QuantityToJson(this);
}