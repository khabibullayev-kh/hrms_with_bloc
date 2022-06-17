// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'education.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Education _$EducationFromJson(Map<String, dynamic> json) => Education(
      id: json['id'] as int,
      name: json['name'] as String,
      nameUz: json['name_uz'] as String,
      nameRu: json['name_ru'] as String,
    );

Map<String, dynamic> _$EducationToJson(Education instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'name_uz': instance.nameUz,
      'name_ru': instance.nameRu,
    };
