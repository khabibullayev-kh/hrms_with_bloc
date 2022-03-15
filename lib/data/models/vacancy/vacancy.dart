import 'package:hrms/data/models/auth_info.dart';
import 'package:hrms/data/models/job_positions/job_position.dart';
import 'package:hrms/data/models/region_district/district.dart';
import 'package:hrms/data/models/states/state.dart';
import 'package:json_annotation/json_annotation.dart';

part 'vacancy.g.dart';

@JsonSerializable()
class Vacancy {
  Vacancy({
    required this.id,
    required this.region,
    required this.creator,
    required this.district,
    required this.branch,
    required this.jobPosition,
    required this.state,
    required this.salary,
    required this.expectedAt,
    required this.bonus,
    required this.requirements,
    required this.description,
    required this.importance,
    this.type,
    required this.mentor,
    required this.quantity,
    required this.activity,
  });

  int? id;
  District? region;
  AuthInfo? creator;
  District? district;
  District? branch;
  District? department;
  JobPosition? jobPosition;
  State? state;
  String? salary;
  String? expectedAt;
  String? bonus;
  String? requirements;
  String? description;
  String? importance;
  dynamic type;
  String? mentor;
  int? quantity;
  Activity? activity;

  factory Vacancy.fromJson(Map<String, dynamic> json) =>
      _$VacancyFromJson(json);

  Map<String, dynamic> toJson() => _$VacancyToJson(this);
}

@JsonSerializable()
class Activity {
  Activity({
    required this.id,
    required this.name,
    required this.tableName,
    required this.objectId,
    required this.user,
    this.commentId,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String name;
  String tableName;
  int objectId;
  AuthInfo user;
  dynamic commentId;
  DateTime createdAt;
  DateTime updatedAt;

  factory Activity.fromJson(Map<String, dynamic> json) =>
      _$ActivityFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityToJson(this);
}
