// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quantity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Quantity _$QuantityFromJson(Map<String, dynamic> json) => Quantity(
      id: json['id'] as int,
      name: json['name'] as String,
      value: json['value'] as int,
    );

Map<String, dynamic> _$QuantityToJson(Quantity instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'value': instance.value,
    };
