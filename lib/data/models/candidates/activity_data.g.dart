// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Activities _$ActivitiesFromJson(Map<String, dynamic> json) => Activities(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => ActivitiesData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ActivitiesToJson(Activities instance) =>
    <String, dynamic>{
      'data': instance.data?.map((e) => e.toJson()).toList(),
    };

ActivitiesData _$ActivitiesDataFromJson(Map<String, dynamic> json) =>
    ActivitiesData(
      id: json['id'] as int?,
      nameRu: json['name_ru'] as String?,
      nameUz: json['name_uz'] as String?,
      tableName: json['table_name'] as String?,
      hint: json['hint'] as String?,
      objectId: json['object_id'] as int?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      user: json['user'] == null
          ? null
          : Director.fromJson(json['user'] as Map<String, dynamic>),
      comment: json['comment'] == null
          ? null
          : Comment.fromJson(json['comment'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ActivitiesDataToJson(ActivitiesData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name_ru': instance.nameRu,
      'name_uz': instance.nameUz,
      'table_name': instance.tableName,
      'hint': instance.hint,
      'object_id': instance.objectId,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'user': instance.user?.toJson(),
      'comment': instance.comment?.toJson(),
    };

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
      id: json['id'] as int,
      message: json['message'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'id': instance.id,
      'message': instance.message,
      'created_at': instance.createdAt.toIso8601String(),
    };
