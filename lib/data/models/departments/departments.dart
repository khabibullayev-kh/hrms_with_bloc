import 'package:hrms/data/models/departments/department.dart';
import 'package:hrms/data/models/meta.dart';
import 'package:json_annotation/json_annotation.dart';

part 'departments.g.dart';

@JsonSerializable()
class Departments {
  @JsonKey(name: 'result')
  final Result result;

  Departments({
    required this.result,
  });

  factory Departments.fromJson(Map<String, dynamic> json) =>
      _$DepartmentsFromJson(json);

  Map<String, dynamic> toJson() => _$DepartmentsToJson(this);
}

@JsonSerializable()
class Result {
  List<Department> departments;
  Meta? meta;

  Result({
    required this.departments,
    required this.meta,
  });

  factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);

  Map<String, dynamic> toJson() => _$ResultToJson(this);
}