
import 'package:json_annotation/json_annotation.dart';

part 'department.g.dart';

@JsonSerializable()
class Department {
  int id;
  String slug;
  String name;
  int jobPositionsCount;
  DateTime createdAt;

  Department({
    required this.id,
    required this.slug,
    required this.name,
    required this.jobPositionsCount,
    required this.createdAt,
  });


  factory Department.fromJson(Map<String, dynamic> json) =>
      _$DepartmentFromJson(json);

  Map<String, dynamic> toJson() => _$DepartmentToJson(this);
}