// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staffs.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Staffs _$StaffsFromJson(Map<String, dynamic> json) => Staffs(
      result: Result.fromJson(json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StaffsToJson(Staffs instance) => <String, dynamic>{
      'result': instance.result.toJson(),
    };

Result _$ResultFromJson(Map<String, dynamic> json) => Result(
      staffs: (json['staffs'] as List<dynamic>)
          .map((e) => Staff.fromJson(e as Map<String, dynamic>))
          .toList(),
      qty: (json['qty'] as List<dynamic>)
          .map((e) => Quantity.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: json['meta'] == null
          ? null
          : Meta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ResultToJson(Result instance) => <String, dynamic>{
      'staffs': instance.staffs.map((e) => e.toJson()).toList(),
      'qty': instance.qty.map((e) => e.toJson()).toList(),
      'meta': instance.meta?.toJson(),
    };
