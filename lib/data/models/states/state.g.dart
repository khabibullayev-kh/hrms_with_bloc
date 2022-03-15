// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

State _$StateFromJson(Map<String, dynamic> json) => State(
      id: json['id'] as int,
      name: json['name'] as String?,
      nameUz: json['name_uz'] as String?,
      nameRu: json['name_ru'] as String?,
      slug: json['slug'] as String?,
      tableName: json['table_name'] as String,
    );

Map<String, dynamic> _$StateToJson(State instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'name_ru': instance.nameRu,
      'name_uz': instance.nameUz,
      'slug': instance.slug,
      'table_name': instance.tableName,
    };
