// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'candidates.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Candidates _$CandidatesFromJson(Map<String, dynamic> json) => Candidates(
      result: Result.fromJson(json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CandidatesToJson(Candidates instance) =>
    <String, dynamic>{
      'result': instance.result.toJson(),
    };

Result _$ResultFromJson(Map<String, dynamic> json) => Result(
      candidates: (json['candidates'] as List<dynamic>)
          .map((e) => Candidate.fromJson(e as Map<String, dynamic>))
          .toList(),
      counts: Counts.fromJson(json['counts'] as Map<String, dynamic>),
      meta: json['meta'] == null
          ? null
          : Meta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ResultToJson(Result instance) => <String, dynamic>{
      'candidates': instance.candidates.map((e) => e.toJson()).toList(),
      'counts': instance.counts.toJson(),
      'meta': instance.meta?.toJson(),
    };

Counts _$CountsFromJson(Map<String, dynamic> json) => Counts(
      hot: json['hot'] as int?,
      countsNew: json['counts_new'] as int?,
      all: json['all'] as int?,
      employed: json['employed'] as int?,
      newVacancies: json['new_vacancies'] as int?,
    );

Map<String, dynamic> _$CountsToJson(Counts instance) => <String, dynamic>{
      'hot': instance.hot,
      'counts_new': instance.countsNew,
      'all': instance.all,
      'employed': instance.employed,
      'new_vacancies': instance.newVacancies,
    };
