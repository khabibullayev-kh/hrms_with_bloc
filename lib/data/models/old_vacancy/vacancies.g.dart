// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vacancies.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Vacancies _$VacanciesFromJson(Map<String, dynamic> json) => Vacancies(
      result: Result.fromJson(json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VacanciesToJson(Vacancies instance) => <String, dynamic>{
      'result': instance.result.toJson(),
    };

Result _$ResultFromJson(Map<String, dynamic> json) => Result(
      vacancies: (json['vacancies'] as List<dynamic>)
          .map((e) => OldVacancy.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: json['meta'] == null
          ? null
          : Meta.fromJson(json['meta'] as Map<String, dynamic>),
      qty: json['qty'] as Object,
    );

Map<String, dynamic> _$ResultToJson(Result instance) => <String, dynamic>{
      'vacancies': instance.vacancies.map((e) => e.toJson()).toList(),
      'meta': instance.meta?.toJson(),
      'qty': instance.qty,
    };
