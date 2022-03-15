// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Shift _$ShiftFromJson(Map<String, dynamic> json) => Shift(
      id: json['id'] as int,
      fullName: json['full_name'] as String?,
      person: json['person'] == null
          ? null
          : Person.fromJson(json['person'] as Map<String, dynamic>),
      fromJobPosition:
          District.fromJson(json['from_job_position'] as Map<String, dynamic>),
      toJobPosition:
          District.fromJson(json['to_job_position'] as Map<String, dynamic>),
      staffId: json['staff_id'] as int?,
      state: State.fromJson(json['state'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['created_at'] as String),
      experience: json['experience'] as String,
      accomplishments: json['accomplishments'] as String,
      violations: json['violations'] as String,
      goal: json['goal'] as String,
      photoUrl: json['photo_url'] as String?,
      canChangeState: json['can_change_state'] as bool,
      fromBranch: Branch.fromJson(json['from_branch'] as Map<String, dynamic>),
      toBranch: Branch.fromJson(json['to_branch'] as Map<String, dynamic>),
      activities:
          Activities.fromJson(json['activities'] as Map<String, dynamic>),
      creator: User.fromJson(json['creator'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ShiftToJson(Shift instance) => <String, dynamic>{
      'id': instance.id,
      'full_name': instance.fullName,
      'person': instance.person?.toJson(),
      'from_job_position': instance.fromJobPosition.toJson(),
      'to_job_position': instance.toJobPosition.toJson(),
      'staff_id': instance.staffId,
      'state': instance.state.toJson(),
      'created_at': instance.createdAt.toIso8601String(),
      'experience': instance.experience,
      'accomplishments': instance.accomplishments,
      'violations': instance.violations,
      'goal': instance.goal,
      'photo_url': instance.photoUrl,
      'can_change_state': instance.canChangeState,
      'from_branch': instance.fromBranch.toJson(),
      'to_branch': instance.toBranch.toJson(),
      'activities': instance.activities.toJson(),
      'creator': instance.creator.toJson(),
    };
