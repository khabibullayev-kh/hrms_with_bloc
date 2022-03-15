// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shifts.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Shifts _$ShiftsFromJson(Map<String, dynamic> json) => Shifts(
      result: Result.fromJson(json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ShiftsToJson(Shifts instance) => <String, dynamic>{
      'result': instance.result.toJson(),
    };

Result _$ResultFromJson(Map<String, dynamic> json) => Result(
      shifts: (json['shifts'] as List<dynamic>)
          .map((e) => Shift.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: json['meta'] == null
          ? null
          : Meta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ResultToJson(Result instance) => <String, dynamic>{
      'shifts': instance.shifts.map((e) => e.toJson()).toList(),
      'meta': instance.meta?.toJson(),
    };
