// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_position.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobPosition _$JobPositionFromJson(Map<String, dynamic> json) => JobPosition(
      id: json['id'] as int,
      slug: json['slug'] as String?,
      nameUz: json['name_uz'] as String?,
      nameRu: json['name_ru'] as String?,
      name: json['name'] as String?,
      department: json['department'] as String?,
    );

Map<String, dynamic> _$JobPositionToJson(JobPosition instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'name_uz': instance.nameUz,
      'name_ru': instance.nameRu,
      'department': instance.department,
    };
