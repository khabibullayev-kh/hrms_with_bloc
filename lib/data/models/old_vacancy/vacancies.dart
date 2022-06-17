import 'package:hrms/data/models/old_vacancy/vacancy.dart';
import 'package:hrms/data/models/users/meta.dart';
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
  List<OldVacancy> vacancies;
  Meta? meta;
  Object qty;

  Result({
    required this.vacancies,
    required this.meta,
    required this.qty,
  });

  factory Result.fromJson(Map<String, dynamic> json) =>
      _$ResultFromJson(json);

  Map<String, dynamic> toJson() => _$ResultToJson(this);
}