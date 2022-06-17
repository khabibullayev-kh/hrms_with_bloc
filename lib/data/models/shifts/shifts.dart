import 'package:hrms/data/models/users/meta.dart';
import 'package:hrms/data/models/shifts/shift.dart';
import 'package:json_annotation/json_annotation.dart';

part 'shifts.g.dart';

@JsonSerializable()
class Shifts {
  @JsonKey(name: 'result')
  final Result result;

  Shifts({
    required this.result,
  });

  factory Shifts.fromJson(Map<String, dynamic> json) =>
      _$ShiftsFromJson(json);

  Map<String, dynamic> toJson() => _$ShiftsToJson(this);
}

@JsonSerializable()
class Result {
  List<Shift> shifts;
  Meta? meta;

  Result({
    required this.shifts,
    required this.meta,
  });

  factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);

  Map<String, dynamic> toJson() => _$ResultToJson(this);
}