import 'package:hrms/data/models/persons/person.dart';
import 'package:json_annotation/json_annotation.dart';

part 'staff.g.dart';

@JsonSerializable()
class Staff {
  Staff({
    required this.id,
    this.person,
    this.personId,
    this.branchId,
    this.jobPosition,
    this.department,
    this.branch,
    this.fullName,
    this.createdAt,
  });

  int id;
  Person? person;
  int? personId;
  int? branchId;
  Object? jobPosition;
  Object? department;
  Object? branch;
  Object? state;
  String? fullName;
  DateTime? createdAt;

  factory Staff.fromJson(Map<String, dynamic> json) => _$StaffFromJson(json);

  Map<String, dynamic> toJson() => _$StaffToJson(this);
}
