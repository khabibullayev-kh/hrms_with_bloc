// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Role _$RoleFromJson(Map<String, dynamic> json) => Role(
      id: json['id'] as int,
      name: json['name'] as String,
      nameUz: json['name_uz'] as String?,
      nameRu: json['name_ru'] as String?,
      permissions: (json['permissions'] as List<dynamic>?)
          ?.map((e) => Permission.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RoleToJson(Role instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'name_uz': instance.nameUz,
      'name_ru': instance.nameRu,
      'permissions': instance.permissions?.map((e) => e.toJson()).toList(),
    };
