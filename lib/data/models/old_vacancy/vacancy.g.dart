// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vacancy.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OldVacancy _$OldVacancyFromJson(Map<String, dynamic> json) => OldVacancy(
      id: json['id'] as int,
      person: json['person'],
      jobPosition: json['job_position'] as String,
      department: json['department'] as String,
      branch: json['branch'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      state: State.fromJson(json['state'] as Map<String, dynamic>),
      candidate: json['candidate'] == null
          ? null
          : Candidate.fromJson(json['candidate'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OldVacancyToJson(OldVacancy instance) =>
    <String, dynamic>{
      'id': instance.id,
      'person': instance.person,
      'job_position': instance.jobPosition,
      'department': instance.department,
      'branch': instance.branch,
      'created_at': instance.createdAt.toIso8601String(),
      'state': instance.state.toJson(),
      'candidate': instance.candidate?.toJson(),
    };
