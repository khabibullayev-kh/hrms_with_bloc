// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'persons.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Persons _$PersonsFromJson(Map<String, dynamic> json) => Persons(
      result: Result.fromJson(json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PersonsToJson(Persons instance) => <String, dynamic>{
      'result': instance.result.toJson(),
    };

Result _$ResultFromJson(Map<String, dynamic> json) => Result(
      persons: (json['persons'] as List<dynamic>)
          .map((e) => Person.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: json['meta'] == null
          ? null
          : Meta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ResultToJson(Result instance) => <String, dynamic>{
      'persons': instance.persons.map((e) => e.toJson()).toList(),
      'meta': instance.meta?.toJson(),
    };
