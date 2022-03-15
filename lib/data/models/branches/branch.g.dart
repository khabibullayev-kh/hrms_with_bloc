// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Branch _$BranchFromJson(Map<String, dynamic> json) => Branch(
      id: json['id'] as int,
      address: json['address'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      name: json['name'] as String?,
      nameUz: json['name_uz'] as String?,
      nameRu: json['name_ru'] as String?,
      region: json['region'] == null
          ? null
          : District.fromJson(json['region'] as Map<String, dynamic>),
      district: json['district'] == null
          ? null
          : District.fromJson(json['district'] as Map<String, dynamic>),
      landmark: json['landmark'] as String?,
      shopCategory: json['shop_category'] as String?,
      slug: json['slug'] as String?,
      director: json['director'] == null
          ? null
          : Director.fromJson(json['director'] as Map<String, dynamic>),
      recruiter: json['recruiter'] == null
          ? null
          : Director.fromJson(json['recruiter'] as Map<String, dynamic>),
      kadr: json['kadr'] == null
          ? null
          : Director.fromJson(json['kadr'] as Map<String, dynamic>),
      regionalManager: json['regional_manager'] == null
          ? null
          : Director.fromJson(json['regional_manager'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BranchToJson(Branch instance) => <String, dynamic>{
      'id': instance.id,
      'address': instance.address,
      'created_at': instance.createdAt?.toIso8601String(),
      'name': instance.name,
      'name_uz': instance.nameUz,
      'name_ru': instance.nameRu,
      'region': instance.region?.toJson(),
      'district': instance.district?.toJson(),
      'landmark': instance.landmark,
      'shop_category': instance.shopCategory,
      'slug': instance.slug,
      'director': instance.director?.toJson(),
      'recruiter': instance.recruiter?.toJson(),
      'kadr': instance.kadr?.toJson(),
      'regional_manager': instance.regionalManager?.toJson(),
    };
