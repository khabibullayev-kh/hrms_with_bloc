// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vacancies.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Vacancies _$VacanciesFromJson(Map<String, dynamic> json) => Vacancies(
      vacancy: (json['data'] as List<dynamic>)
          .map((e) => Vacancy.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: json['meta'] == null
          ? null
          : Meta.fromJson(json['meta'] as Map<String, dynamic>),
      sum: json['sum'] as Object,
    );

Map<String, dynamic> _$VacanciesToJson(Vacancies instance) => <String, dynamic>{
      'data': instance.vacancy.map((e) => e.toJson()).toList(),
      'meta': instance.meta?.toJson(),
      'sum': instance.sum,
    };
