import 'package:hrms/data/models/branches/branch.dart';
import 'package:hrms/data/models/job_positions/job_position.dart';
import 'package:hrms/data/models/region_district/district.dart';
import 'package:hrms/data/models/candidates/activity_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'candidate.g.dart';

@JsonSerializable()
class Candidate {
  int? id;
  String? firstName;
  String? lastName;
  String? fatherName;
  String? fullName;
  DateTime? dateOfBirth;
  String? maritalStatus;
  String? speciality;
  String? address;
  String? phone;
  String? level;
  String? sex;
  String? additionalPhone;
  String? currentWork;
  String? periodOfStudy;
  String? candidateNote;
  String? desiredSalary;
  String? relatives;
  AdSource? adSource;
  String? photoUrl;
  JobPosition? jobPosition;
  District? district;
  AdSource? state;
  DateTime? updatedAt;
  District? education;
  dynamic cancelCause;
  String? heightWeight;
  String? isStudent;
  String? citizenship;
  String? isWorkedBefore;
  dynamic isNowWorked;
  Activities? activities;
  Short? shortSkills;
  Short? shortLanguages;
  Short? documents;
  District? region;
  DateTime? createdAt;
  bool? canChangeState;
  Branch? branch;
  CandidateVacancy? vacancy;

  Candidate({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.fatherName,
    required this.fullName,
    this.dateOfBirth,
    this.maritalStatus,
    this.speciality,
    this.address,
    this.phone,
    this.level,
    this.sex,
    this.additionalPhone,
    this.currentWork,
    this.periodOfStudy,
    this.candidateNote,
    this.desiredSalary,
    this.relatives,
    this.adSource,
    this.photoUrl,
    required this.jobPosition,
    this.district,
    this.state,
    this.updatedAt,
    this.education,
    this.cancelCause,
    this.heightWeight,
    this.isStudent,
    this.citizenship,
    this.isWorkedBefore,
    this.isNowWorked,
    required this.canChangeState,
    required this.branch,
    this.activities,
    this.shortSkills,
    this.shortLanguages,
    this.documents,
    required this.region,
    required this.createdAt,
    this.vacancy
  });

  factory Candidate.fromJson(Map<String, dynamic> json) =>
      _$CandidateFromJson(json);

  Map<String, dynamic> toJson() => _$CandidateToJson(this);
}

@JsonSerializable()
class Short {
  Short({
    required this.data,
  });

  List<District>? data;

  factory Short.fromJson(Map<String, dynamic> json) =>
      _$ShortFromJson(json);

  Map<String, dynamic> toJson() => _$ShortToJson(this);
}

@JsonSerializable()
class AdSource {
  AdSource({
    required this.id,
    required this.nameUz,
    required this.nameRu,
    this.tableName,
  });

  int id;
  String nameUz;
  String nameRu;
  String? tableName;

  factory AdSource.fromJson(Map<String, dynamic> json) =>
      _$AdSourceFromJson(json);

  Map<String, dynamic> toJson() => _$AdSourceToJson(this);
}

@JsonSerializable()
class CandidateVacancy {
  int id;
  int jobPositionId;
  String jobPositionNameUz;
  String jobPositionNameRu;

  CandidateVacancy({
    required this.id,
    required this.jobPositionId,
    required this.jobPositionNameUz,
    required this.jobPositionNameRu,
  });

  factory CandidateVacancy.fromJson(Map<String, dynamic> json) =>
      _$CandidateVacancyFromJson(json);

  Map<String, dynamic> toJson() => _$CandidateVacancyToJson(this);
}
