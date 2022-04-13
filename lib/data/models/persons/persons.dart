import 'package:hrms/data/models/users/meta.dart';
import 'package:hrms/data/models/persons/person.dart';
import 'package:json_annotation/json_annotation.dart';

part 'persons.g.dart';

@JsonSerializable()
class Persons {
  @JsonKey(name: 'result')
  final Result result;

  Persons({
    required this.result,
  });

  factory Persons.fromJson(Map<String, dynamic> json) =>
      _$PersonsFromJson(json);

  Map<String, dynamic> toJson() => _$PersonsToJson(this);
}

@JsonSerializable()
class Result {
  List<Person> persons;
  Meta? meta;

  Result({
    required this.persons,
    required this.meta,
  });

  factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);

  Map<String, dynamic> toJson() => _$ResultToJson(this);
}