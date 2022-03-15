import 'package:hrms/data/models/meta.dart';
import 'package:hrms/data/models/staffs/staff.dart';
import 'package:hrms/data/models/vacancy/vacancy.dart';
import 'package:json_annotation/json_annotation.dart';

part 'vacancies.g.dart';

@JsonSerializable()
class Vacancies {
  @JsonKey(name: 'data')
  List<Vacancy> vacancy;
  Meta? meta;
  Object sum;

  Vacancies({
    required this.vacancy,
    required this.meta,
    required this.sum,
  });

  factory Vacancies.fromJson(Map<String, dynamic> json) =>
      _$VacanciesFromJson(json);

  Map<String, dynamic> toJson() => _$VacanciesToJson(this);
}