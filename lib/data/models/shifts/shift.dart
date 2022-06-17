import 'package:hrms/data/models/branches/branch.dart';
import 'package:hrms/data/models/persons/person.dart';
import 'package:hrms/data/models/region_district/district.dart';
import 'package:hrms/data/models/states/state.dart';
import 'package:hrms/data/models/candidates/activity_data.dart';
import 'package:hrms/data/models/users/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'shift.g.dart';

@JsonSerializable()
class Shift {
  Shift({
    required this.id,
    this.fullName,
    this.person,
    required this.fromJobPosition,
    required this.toJobPosition,
    this.staffId,
    required this.state,
    required this.createdAt,
    required this.experience,
    required this.accomplishments,
    required this.violations,
    required this.goal,
    this.photoUrl,
    required this.canChangeState,
    required this.fromBranch,
    required this.toBranch,
    required this.activities,
    required this.creator,
  });

  int id;
  String? fullName;
  Person? person;
  District fromJobPosition;
  District toJobPosition;
  int? staffId;
  State state;
  DateTime createdAt;
  String experience;
  String accomplishments;
  String violations;
  String goal;
  String? photoUrl;
  bool canChangeState;
  Branch fromBranch;
  Branch toBranch;
  Activities activities;
  User creator;

  factory Shift.fromJson(Map<String, dynamic> json) => _$ShiftFromJson(json);

  Map<String, dynamic> toJson() => _$ShiftToJson(this);
}