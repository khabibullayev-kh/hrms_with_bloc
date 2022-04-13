// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Statistics _$StatisticsFromJson(Map<String, dynamic> json) => Statistics(
      id: json['id'] as int,
      label: json['label'] as String?,
      name: json['name'] as String?,
      sortId: json['sort_id'] as int?,
      value: json['value'] as int,
    );

Map<String, dynamic> _$StatisticsToJson(Statistics instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'name': instance.name,
      'sort_id': instance.sortId,
      'value': instance.value,
    };
