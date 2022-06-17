// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'departments.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Departments _$DepartmentsFromJson(Map<String, dynamic> json) => Departments(
      result: Result.fromJson(json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DepartmentsToJson(Departments instance) =>
    <String, dynamic>{
      'result': instance.result.toJson(),
    };

Result _$ResultFromJson(Map<String, dynamic> json) => Result(
      departments: (json['departments'] as List<dynamic>)
          .map((e) => Department.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: json['meta'] == null
          ? null
          : Meta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ResultToJson(Result instance) => <String, dynamic>{
      'departments': instance.departments.map((e) => e.toJson()).toList(),
      'meta': instance.meta?.toJson(),
    };
