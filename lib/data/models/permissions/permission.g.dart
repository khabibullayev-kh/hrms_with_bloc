// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permission.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Permission _$PermissionFromJson(Map<String, dynamic> json) => Permission(
      id: json['id'] as int,
      name: json['name'] as String,
      nameUz: json['name_uz'] as String,
      nameRu: json['name_ru'] as String,
    );

Map<String, dynamic> _$PermissionToJson(Permission instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'name_uz': instance.nameUz,
      'name_ru': instance.nameRu,
    };
