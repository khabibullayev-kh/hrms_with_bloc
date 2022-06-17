import 'package:hrms/data/models/users/meta.dart';
import 'package:hrms/data/models/staffs/staff.dart';
import 'package:hrms/data/models/vacancy/vacancy.dart';
import 'package:json_annotation/json_annotation.dart';

part 'vacancies.g.dart';
@JsonSerializable()
class Vacancies {
  @JsonKey(name: 'result')
  final Result result;

  Vacancies({
    required this.result,
  });

  factory Vacancies.fromJson(Map<String, dynamic> json) =>
      _$VacanciesFromJson(json);

  Map<String, dynamic> toJson() => _$VacanciesToJson(this);
}

@JsonSerializable()
class Result {
  List<Vacancy> vacancies;
  Meta? meta;
  Object sum;

  Result({
    required this.vacancies,
    required this.meta,
    required this.sum,
  });

  factory Result.fromJson(Map<String, dynamic> json) =>
      _$ResultFromJson(json);

  Map<String, dynamic> toJson() => _$ResultToJson(this);
}