// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Staff _$StaffFromJson(Map<String, dynamic> json) => Staff(
      id: json['id'] as int,
      person: json['person'] == null
          ? null
          : Person.fromJson(json['person'] as Map<String, dynamic>),
      personId: json['person_id'] as int?,
      branchId: json['branch_id'] as int?,
      jobPosition: json['job_position'],
      department: json['department'],
      branch: json['branch'],
      fullName: json['full_name'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      client: json['description'] as String?,
    )..state = json['state'];

Map<String, dynamic> _$StaffToJson(Staff instance) => <String, dynamic>{
      'id': instance.id,
      'person': instance.person?.toJson(),
      'person_id': instance.personId,
      'branch_id': instance.branchId,
      'job_position': instance.jobPosition,
      'department': instance.department,
      'branch': instance.branch,
      'state': instance.state,
      'full_name': instance.fullName,
      'created_at': instance.createdAt?.toIso8601String(),
      'description': instance.client,
    };
