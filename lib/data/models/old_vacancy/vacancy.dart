import 'package:hrms/data/models/auth_info.dart';
import 'package:hrms/data/models/candidates/candidate.dart';
import 'package:hrms/data/models/job_positions/job_position.dart';
import 'package:hrms/data/models/region_district/district.dart';
import 'package:hrms/data/models/states/state.dart';
import 'package:json_annotation/json_annotation.dart';

part 'vacancy.g.dart';

@JsonSerializable()
class OldVacancy {
  OldVacancy({
    required this.id,
    required this.person,
    required this.jobPosition,
    required this.department,
    required this.branch,
    required this.createdAt,
    required this.state,
    this.candidate,
  });

  int id;
  dynamic person;
  String jobPosition;
  String department;
  String branch;
  DateTime createdAt;
  State state;
  Candidate? candidate;

  factory OldVacancy.fromJson(Map<String, dynamic> json) =>
      _$OldVacancyFromJson(json);

  Map<String, dynamic> toJson() => _$OldVacancyToJson(this);
}
